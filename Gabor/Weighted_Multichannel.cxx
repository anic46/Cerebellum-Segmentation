#include "itkVectorDiffeomorphicDemonsRegistrationFilter.h"
#include "itkVectorImageWarpFilter.h"
#include "itkCommand.h"
#include "itkVector.h"
#include "itkArray.h"
#include "itkVectorImage.h"
#include "itkVariableLengthVector.h"
#include "itkImageFileReader.h"
#include "itkImageFileWriter.h"
#include "itkTransformFileReader.h"
#include "itkTransformToDeformationFieldFilter.h"
#include "itkPDEDeformableRegistrationFilter.h"
#include "itkVectorMultiResolutionPDEDeformableRegistration.h"
#include "itkHistogramMatchingImageFilter.h"
#include "itkVectorLinearInterpolateNearestNeighborExtrapolateImageFunction.h"
#include "itkMinimumMaximumImageCalculator.h"
#include "itkWarpJacobianDeterminantFilter.h"
#include "itkWarpHarmonicEnergyCalculator.h"
#include "itkRecursiveMultiResolutionPyramidImageFilter.h"
#include "itkVectorCentralDifferenceImageFunction.h"

#include <iostream>
#include "Weighted_MultichannelCLP.h"


template <class TPixel=float, unsigned int VImageDimension=3>
class CommandIterationUpdate : public itk::Command 
{
public:
   typedef  CommandIterationUpdate   Self;
   typedef  itk::Command             Superclass;
   typedef  itk::SmartPointer<Self>  Pointer;

   typedef itk::Image< TPixel, VImageDimension > InternalImageType;
   typedef itk::Vector< TPixel, VImageDimension >    VectorPixelType;
   typedef itk::Image<  VectorPixelType, VImageDimension > DeformationFieldType;
   typedef itk::VectorImage<TPixel, VImageDimension> VectorImageType;

   typedef itk::VectorDiffeomorphicDemonsRegistrationFilter<
      VectorImageType,
      VectorImageType,
      DeformationFieldType>   DiffeomorphicDemonsRegistrationFilterType;

   typedef itk::VectorMultiResolutionPDEDeformableRegistration<
      VectorImageType, VectorImageType,
      DeformationFieldType, TPixel >   MultiResRegistrationFilterType;

   typedef itk::WarpJacobianDeterminantFilter<
      DeformationFieldType, InternalImageType> JacobianFilterType;
   
   typedef itk::MinimumMaximumImageCalculator<InternalImageType> MinMaxFilterType;

   typedef itk::WarpHarmonicEnergyCalculator<DeformationFieldType>
      HarmonicEnergyCalculatorType;

   typedef itk::VectorCentralDifferenceImageFunction<DeformationFieldType>
      WarpGradientCalculatorType;

   typedef typename WarpGradientCalculatorType::OutputType WarpGradientType;
   
   itkNewMacro( Self );

private:
   std::ofstream m_Fid;
   bool m_headerwritten;
   typename JacobianFilterType::Pointer m_JacobianFilter;
   typename MinMaxFilterType::Pointer m_Minmaxfilter;
   typename HarmonicEnergyCalculatorType::Pointer m_HarmonicEnergyCalculator;
   typename DeformationFieldType::ConstPointer m_TrueField;
   typename WarpGradientCalculatorType::Pointer m_TrueWarpGradientCalculator;
   typename WarpGradientCalculatorType::Pointer m_CompWarpGradientCalculator;

public:
   void SetTrueField(const DeformationFieldType * truefield)
   {
      m_TrueField = truefield;

      m_TrueWarpGradientCalculator = WarpGradientCalculatorType::New();
      m_TrueWarpGradientCalculator->SetInputImage( m_TrueField );
      m_CompWarpGradientCalculator =  WarpGradientCalculatorType::New();
   }
   
   void Execute(itk::Object *caller, const itk::EventObject & event)
   {
      Execute( (const itk::Object *)caller, event);
   }

   void Execute(const itk::Object * object, const itk::EventObject & event)
   {
      if( !(itk::IterationEvent().CheckEvent( &event )) )
      {
         return;
      }

      typename DeformationFieldType::ConstPointer deffield = 0;
      unsigned int iter = -1;
      double metricbefore = -1.0;
      
      if ( const DiffeomorphicDemonsRegistrationFilterType * filter = 
           dynamic_cast< const DiffeomorphicDemonsRegistrationFilterType * >( object ) )
      {
         iter = filter->GetElapsedIterations() - 1;
         metricbefore = filter->GetMetric();
         deffield = const_cast<DiffeomorphicDemonsRegistrationFilterType *>
            (filter)->GetDeformationField();
      }
          else
      {
         return;
      }

      if (deffield)
      {
         std::cout<<iter<<": MSE "<<metricbefore<<" - ";

         double fieldDist = -1.0;
         double fieldGradDist = -1.0;
         double tmp;
         if (m_TrueField)
         {
            typedef itk::ImageRegionConstIteratorWithIndex<DeformationFieldType>
               FieldIteratorType;
            FieldIteratorType currIter(
               deffield, deffield->GetLargestPossibleRegion() );
            FieldIteratorType trueIter(
               m_TrueField, deffield->GetLargestPossibleRegion() );

            m_CompWarpGradientCalculator->SetInputImage( deffield );

            fieldDist = 0.0;
            fieldGradDist = 0.0;
            for ( currIter.GoToBegin(), trueIter.GoToBegin();
                  ! currIter.IsAtEnd(); ++currIter, ++trueIter )
            {
               fieldDist += (currIter.Value() - trueIter.Value()).GetSquaredNorm();

               // No need to add Id matrix here as we do a substraction
               tmp = (
                  ( m_CompWarpGradientCalculator->EvaluateAtIndex(currIter.GetIndex())
                    -m_TrueWarpGradientCalculator->EvaluateAtIndex(trueIter.GetIndex())
                     ).GetVnlMatrix() ).frobenius_norm();
               fieldGradDist += tmp*tmp;
            }
            fieldDist = sqrt( fieldDist/ (double)(
                     deffield->GetLargestPossibleRegion().GetNumberOfPixels()) );
            fieldGradDist = sqrt( fieldGradDist/ (double)(
                     deffield->GetLargestPossibleRegion().GetNumberOfPixels()) );
            
            std::cout<<"d(.,true) "<<fieldDist<<" - ";
            std::cout<<"d(.,Jac(true)) "<<fieldGradDist<<" - ";
         }
         
         m_HarmonicEnergyCalculator->SetImage( deffield );
         m_HarmonicEnergyCalculator->Compute();
         const double harmonicEnergy
            = m_HarmonicEnergyCalculator->GetHarmonicEnergy();
         std::cout<<"harmo. "<<harmonicEnergy<<" - ";

         
         m_JacobianFilter->SetInput( deffield );
         m_JacobianFilter->UpdateLargestPossibleRegion();

        
         const unsigned int numPix = m_JacobianFilter->
            GetOutput()->GetLargestPossibleRegion().GetNumberOfPixels();
         
         TPixel* pix_start = m_JacobianFilter->GetOutput()->GetBufferPointer();
         TPixel* pix_end = pix_start + numPix;

         TPixel* jac_ptr;

         // Get percentage of det(Jac) below 0
         unsigned int jacBelowZero(0u);
         for (jac_ptr=pix_start; jac_ptr!=pix_end; ++jac_ptr)
         {
            if ( *jac_ptr<=0.0 ) ++jacBelowZero;
         }
         const double jacBelowZeroPrc = static_cast<double>(jacBelowZero)
            / static_cast<double>(numPix);
         

         // Get min an max jac
         const double minJac = *(std::min_element (pix_start, pix_end));
         const double maxJac = *(std::max_element (pix_start, pix_end));

         // Get some quantiles
         // We don't need the jacobian image
         // we can modify/sort it in place
         jac_ptr = pix_start + static_cast<unsigned int>(0.002*numPix);
         std::nth_element(pix_start, jac_ptr, pix_end);
         const double Q002 = *jac_ptr;

         jac_ptr = pix_start + static_cast<unsigned int>(0.01*numPix);
         std::nth_element(pix_start, jac_ptr, pix_end);
         const double Q01 = *jac_ptr;

         jac_ptr = pix_start + static_cast<unsigned int>(0.99*numPix);
         std::nth_element(pix_start, jac_ptr, pix_end);
         const double Q99 = *jac_ptr;

         jac_ptr = pix_start + static_cast<unsigned int>(0.998*numPix);
         std::nth_element(pix_start, jac_ptr, pix_end);
         const double Q998 = *jac_ptr;
         

         std::cout<<"max|Jac| "<<maxJac<<" - "
                  <<"min|Jac| "<<minJac<<" - "
                  <<"ratio(|Jac|<=0) "<<jacBelowZeroPrc<<std::endl;
         
         

         if (this->m_Fid.is_open())
         {
            if (! m_headerwritten)
            {
               this->m_Fid<<"Iteration"
                          <<", MSE before"
                          <<", Harmonic energy"
                          <<", min|Jac|"
                          <<", 0.2% |Jac|"
                          <<", 01% |Jac|"
                          <<", 99% |Jac|"
                          <<", 99.8% |Jac|"
                          <<", max|Jac|"
                          <<", ratio(|Jac|<=0)";
               
               if (m_TrueField)
               {
                  this->m_Fid<<", dist(warp,true warp)"
                             <<", dist(Jac,true Jac)";
               }
               
               this->m_Fid<<std::endl;
               
               m_headerwritten = true;
            }
            
            this->m_Fid<<iter
                       <<", "<<metricbefore
                       <<", "<<harmonicEnergy
                       <<", "<<minJac
                       <<", "<<Q002
                       <<", "<<Q01
                       <<", "<<Q99
                       <<", "<<Q998
                       <<", "<<maxJac
                       <<", "<<jacBelowZeroPrc;

            if (m_TrueField)
            {
               this->m_Fid<<", "<<fieldDist
                          <<", "<<fieldGradDist;
            }
            
            this->m_Fid<<std::endl;
         }
      }
   }
   
protected:   
   CommandIterationUpdate() :
      m_Fid( "metricvalues.csv" ),
      m_headerwritten(false)
   {
      m_JacobianFilter = JacobianFilterType::New();
      m_JacobianFilter->SetUseImageSpacing( true );
      m_JacobianFilter->ReleaseDataFlagOn();
      
      m_Minmaxfilter = MinMaxFilterType::New();

      m_HarmonicEnergyCalculator = HarmonicEnergyCalculatorType::New();

      m_TrueField = 0;
      m_TrueWarpGradientCalculator = 0;
      m_CompWarpGradientCalculator = 0;
   };

   ~CommandIterationUpdate()
   {
      this->m_Fid.close();
   }
};



int main( int argc, char *argv[] )
{
   PARSE_ARGS;
   
  std::cout << "Moving Image: " <<  movingVolume << std::endl; 
  std::cout << "Fixed Image: " <<  fixedVolume << std::endl; 
  std::cout << "Input Deformation Field:" <<  inputDeformationField << std::endl; 
  std::cout << "Input Transform Filename: " << inputTransform << std::endl;
  std::cout << "Output Image Filename: " << outputVolume << std::endl; 
  std::cout << "Output Deformation Field: " << outputDeformationField <<std::endl;
  std::cout << "Number of Levels: " << NumLevels <<std::endl;
  std::cout << "Iterations : " << Iterations.size() << std::endl;    
  std::cout << "Sigma Def: " << SigmaDef <<std::endl;
  std::cout << "Sigma Up: "  << SigmaUp <<std::endl;
  std::cout << "Max Step Length: " << MaxLength<<std::endl;
  std::cout << "update Rule: " <<UpdateRule <<std::endl;
  std::cout << "Gradient Type: " << Gradient<<std::endl;
  std::cout << "Verbosity: " << Verbosity <<std::endl;
  std::cout << "Weights : " << Weights.size() << std::endl;  
 
 const    unsigned int    Dimension = 3;
 typedef float PixelType;
 typedef itk::VectorImage< PixelType, Dimension >  ImageType;
 typedef itk::Vector< PixelType, Dimension >    VectorPixelType;
 typedef itk::Image< VectorPixelType, Dimension > DeformationFieldType;
 typedef itk::VariableLengthVector<float> realPixelType;

  
 // Set up the file readers
 typedef itk::ImageFileReader< ImageType > FixedImageReaderType;
 typedef itk::ImageFileReader< ImageType > MovingImageReaderType;
 typedef itk::ImageFileReader< DeformationFieldType > FieldReaderType;
 typedef itk::TransformFileReader TransformReaderType;

 typedef itk::Array<unsigned int> UnsignedIntArray;
 UnsignedIntArray  numIterations(Iterations.size()); 
 
 

 for (int i =0; i<Iterations.size(); i++)
 
 {
   
   numIterations[i] = static_cast<unsigned int>(Iterations[i]);
   std::cout << "Iterations at level" << i << " are: " << numIterations[i] << std::endl;
 }

 ImageType::Pointer fixedImage = ImageType::New();
 ImageType::Pointer movingImage = ImageType::New();
 
 
 FixedImageReaderType::Pointer  fixedImageReader  = FixedImageReaderType::New();
 MovingImageReaderType::Pointer movingImageReader = MovingImageReaderType::New();
 
 fixedImageReader->SetFileName( fixedVolume );
 movingImageReader->SetFileName( movingVolume );
 
 
 
 // Update the reader
   try
   {
      std::cout << " Reading Fixed and Moving Images ....." << std::endl;
      fixedImageReader->Update();
      movingImageReader->Update();
     
   }
   catch( itk::ExceptionObject& err )
   {
      std::cout << "Could not read one of the input images." << std::endl;
      std::cout << err << std::endl;
      exit( EXIT_FAILURE );
   }
  
   DeformationFieldType::Pointer inputDefField;
   
 if (inputDeformationField.length()> 0)
 {
      // Set up the file readers
      FieldReaderType::Pointer fieldReader = FieldReaderType::New();
      fieldReader->SetFileName(  inputDeformationField );
      
      // Update the reader
      try
      {
         std::cout << " Reading Initial Deformation Field ....." << std::endl;
	 fieldReader->Update();
      }
      catch( itk::ExceptionObject& err )
      {
         std::cout << "Could not read the input field." << std::endl;
         std::cout << err << std::endl;
         exit( EXIT_FAILURE );
      }
      inputDefField = fieldReader->GetOutput();
      inputDefField->DisconnectPipeline();
  
  }
 
  else if ( inputTransform.length()> 0)
  {
   TransformReaderType::Pointer transformReader = TransformReaderType::New(); 
   transformReader->SetFileName(  inputTransform );
      
      // Update the reader
      try
      {
         std::cout << " Reading Initial Transform ....." << std::endl;
	 transformReader->Update();
	 
      }
      catch( itk::ExceptionObject& err )
      {
         std::cout << "Could not read the input transform." << std::endl;
         std::cout << err << std::endl;
         exit( EXIT_FAILURE );
      }
      
     typedef TransformReaderType::TransformType BaseTransformType;
     BaseTransformType* baseTrsf(0);

     const TransformReaderType::TransformListType* trsflistptr = transformReader->GetTransformList();
      if ( trsflistptr->empty() )
      {
         std::cout << "Could not read the input transform." << std::endl;
         exit( EXIT_FAILURE );
      }
      else if (trsflistptr->size()>1 )
      {
         std::cout << "The input transform file contains more than one transform, we use the first one." << std::endl;
         exit( EXIT_FAILURE );
      }

      baseTrsf = trsflistptr->front();
      if ( !baseTrsf )
      {
         std::cout << "Could not read the input transform." << std::endl;
         exit( EXIT_FAILURE );
      }
      

      // Set up the TransformToDeformationFieldFilter
      typedef itk::TransformToDeformationFieldFilter <DeformationFieldType> FieldGeneratorType;
      typedef FieldGeneratorType::TransformType TransformType;

      TransformType* trsf = dynamic_cast<TransformType*>(baseTrsf);
      if ( !trsf )
      {
         std::cout << "Could not cast input transform to a usable transform." << std::endl;
         exit( EXIT_FAILURE );
      }

     FieldGeneratorType::Pointer fieldGenerator = FieldGeneratorType::New();
      fieldGenerator->SetTransform( trsf );
      fieldGenerator->SetOutputRegion( fixedImageReader->GetOutput()->GetRequestedRegion());
      fieldGenerator->SetOutputSpacing(fixedImageReader->GetOutput()->GetSpacing());
      fieldGenerator->SetOutputOrigin( fixedImageReader->GetOutput()->GetOrigin());
      fieldGenerator->SetOutputDirection( fixedImageReader->GetOutput()->GetDirection());

      // Update the fieldGenerator
      try
      {
         fieldGenerator->Update();
      }
      catch( itk::ExceptionObject& err )
      {
         std::cout << "Could not generate the input field." << std::endl;
         std::cout << err << std::endl;
         exit( EXIT_FAILURE );
      }

     inputDefField = fieldGenerator->GetOutput();
     inputDefField->DisconnectPipeline();
   }
      
 
  fixedImage = fixedImageReader->GetOutput();
  movingImage = movingImageReader->GetOutput();
  
  int VectorLength = fixedImage->GetVectorLength();
  std::cout << "VectorLength = " << VectorLength <<std::endl;  
  
  
    
    std::cout << "Use Diffeomorphic Registration" << std::endl;
     typedef itk::VectorDiffeomorphicDemonsRegistrationFilter < ImageType, ImageType, DeformationFieldType>
         ActualRegistrationFilterType;
     typedef  ActualRegistrationFilterType::GradientType GradientType;    
    ActualRegistrationFilterType::Pointer actualfilter = ActualRegistrationFilterType::New();     
       actualfilter->SetMaximumUpdateStepLength( MaxLength );
     actualfilter->SetUseGradientType( static_cast<GradientType>(Gradient) );
     /*actualfilter->SetFixedImage( fixedImage );
	 actualfilter->SetMovingImage( movingImage );
	 actualfilter->SetInitialDeformationField( inputDefField );*/
    
       
    
   if ( SigmaDef > 0.1)
   {
      std::cout << " Smoothing is on ....." << std::endl;
      actualfilter->SmoothDeformationFieldOn();
      actualfilter->SetStandardDeviations( SigmaDef );
   }
   else
   {
      actualfilter->SmoothDeformationFieldOff();
   }

   if ( SigmaUp > 0.1 )
   {
     std::cout << " Smoothing at update....." << std::endl;
      actualfilter->SmoothUpdateFieldOn();
      actualfilter->SetUpdateFieldStandardDeviations( SigmaUp );
   }
   else
   {
      actualfilter->SmoothUpdateFieldOff();
   } 
   
   typedef itk::VectorLinearInterpolateNearestNeighborExtrapolateImageFunction<DeformationFieldType,double> FieldInterpolatorType;	  
   FieldInterpolatorType::Pointer VectorInterpolator = FieldInterpolatorType::New();
  
   
     // Set up the multi-resolution filter
   typedef itk::VectorMultiResolutionPDEDeformableRegistration< ImageType, ImageType, DeformationFieldType, float >   MultiResRegistrationFilterType;
   MultiResRegistrationFilterType::Pointer multires = MultiResRegistrationFilterType::New();
   multires->SetRegistrationFilter( actualfilter );
   multires->SetNumberOfLevels( NumLevels );
   multires->SetNumberOfIterations( numIterations.data_block() );
   multires->SetFixedImage( fixedImage );
   multires->SetMovingImage( movingImage );
   multires->SetInitialDeformationField( inputDefField );
   multires->GetFieldExpander()->SetInterpolator(VectorInterpolator);
  
  
      CommandIterationUpdate<PixelType, Dimension>::Pointer multiresobserver =
         CommandIterationUpdate<PixelType, Dimension>::New();
      actualfilter->AddObserver( itk::IterationEvent(), multiresobserver );
      
      CommandIterationUpdate<PixelType, Dimension>::Pointer multiresobserver1 =
         CommandIterationUpdate<PixelType, Dimension>::New();
     multires->AddObserver( itk::IterationEvent(), multiresobserver );
      
   
   try
   {
      std::cout << " Computing the Deformation Field ....." << std::endl;
      multires->Update();
     
   }
   catch( itk::ExceptionObject& err )
   {
      std::cout << "Unexpected error." << std::endl;
      std::cout << err << std::endl;
      exit( EXIT_FAILURE );
   }

   // The outputs
  DeformationFieldType::Pointer defField = multires->GetOutput();
  defField->DisconnectPipeline();
  
 // warp the result
  typedef itk::VectorImageWarpFilter < ImageType, ImageType, DeformationFieldType >  WarperType;
  WarperType::Pointer warper = WarperType::New();
  warper->SetInput( movingImage );
  warper->SetOutputSpacing( fixedImage->GetSpacing() );
  warper->SetOutputOrigin( fixedImage->GetOrigin() );
  warper->SetOutputDirection( fixedImage->GetDirection() );
  warper->SetDeformationField( defField );
  warper->SetVectorLength(VectorLength); 
  warper->Update();
  
  // Write warped image out to file
   typedef PixelType OutputPixelType;
   typedef itk::ImageFileWriter< ImageType >  WriterType;
   WriterType::Pointer  writer =  WriterType::New();
   writer->SetFileName( outputVolume );
   writer->SetInput( warper->GetOutput()   );
   
   
   try
   {
      writer->Update();
      std::cout << " Writing output resampled image ....." << std::endl;
   }
   catch( itk::ExceptionObject& err )
   {
      std::cout << "Unexpected error." << std::endl;
      std::cout << err << std::endl;
      exit( EXIT_FAILURE );
   }
   
  // Write deformation field
   if (outputDeformationField.length() > 0)
   {
      
      typedef itk::ImageFileWriter< DeformationFieldType > FieldWriterType;
      FieldWriterType::Pointer fieldWriter = FieldWriterType::New();
      fieldWriter->SetFileName( outputDeformationField );
      fieldWriter->SetInput( defField );
          
      try
      {
         fieldWriter->Update();
	 std::cout << " Writing output Deformation Field ....." << std::endl;
      }
      catch( itk::ExceptionObject& err )
      {
         std::cout << "Unexpected error." << std::endl;
         std::cout << err << std::endl;
         exit( EXIT_FAILURE );
      }
   }
   
  
  return 0;
}

   
