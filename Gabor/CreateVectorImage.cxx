/*--------------------------------------------------------
----------------------------------------------------------
This program creates a vector image from n number of scalar 
images. Please define the number of channels and set the input 
images. This program will not take the tensor components. 
If you want to use scalars and tensor componentts together 
please use CreateTensorVectorImage.cxx for that. If you are
using this program for implementing Multichannel registration 
in the next step, make sure that all the scalar images are 
normalized and histogram matched.


Author: Madhura A. Ingalhalikar
University of Iowa, Iowa City IA. 
---------------------------------------------------------
----------------------------------------------------------*/
#include "itkImageFileWriter.h"
#include "itkImageFileReader.h"
#include "itkImage.h"
#include "itkVector.h"
#include "itkVectorImage.h"
#include <iostream>
#include "itkImageToVectorImageFilter.h"
#include "CreateVectorImageCLP.h"



int main( int argc, char* argv[] )
{

PARSE_ARGS;


  std::cout << " Input Images : " << InputVolume.size() << std::endl;
  std::cout << " Output Vector Image: "<< OutputVolume << std::endl;
 
  
  typedef float PixelType;
  const unsigned int dimension = 3;
  typedef itk::Image<PixelType,dimension>		ImageType;
  typedef itk::VectorImage<PixelType, dimension> 	VectorImageType;
  typedef itk::ImageFileReader<ImageType>    		ReaderType;
  typedef itk::ImageFileWriter<VectorImageType> 	WriterType;
 
  

  ReaderType::Pointer reader = ReaderType::New();
  WriterType::Pointer writer = WriterType::New();
  
  typedef itk::ImageToVectorImageFilter<ImageType> VecFilterType;
  VecFilterType::Pointer vecFilter = VecFilterType::New();
  
  ImageType::Pointer image = ImageType::New();
 
 for (unsigned int i= 0; i<InputVolume.size(); i++)
 { 
 
   reader->SetFileName(InputVolume[i] );
   std::cout << "Reading Volume .... "<< InputVolume[i] << std::endl;
		  
 	 try
  	{
    	reader->Update();
  	}
 	 catch (itk::ExceptionObject &ex)
  	{
   	 std::cout << ex << std::endl;
   	 throw;
 	}
  
  image = reader->GetOutput(); 
  vecFilter->SetNthInput( i, image );   
  image->DisconnectPipeline();
  }

  
  vecFilter->Update();
 
  VectorImageType::Pointer vectorImage = vecFilter->GetOutput();
  std::cout << vectorImage <<std::endl; 
  std::cout  << "Writing out vector image.. " << std::endl ;
  writer->SetFileName( OutputVolume );
  writer->SetInput(vectorImage);
    
    try
      {
      writer->Update();
      
      }
    catch (itk::ExceptionObject &ex)
      {
      std::cout << ex;
      return EXIT_FAILURE;
      }
  
   

  return EXIT_SUCCESS;

}
