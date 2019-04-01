
origAC=[84.0, 134.0, 148.0];
origOrient=[-0.9977484, 0.049010877, 0.045783557; -0.049062323, -0.9987957, 0.0; 0.045728423, -0.0022462478, 0.99895144];
origDim=[166 256 256];
origPC=[83 108 148];
origRes=[1.2035718, 0.9423825, 0.9415575];
acpcAC=[95.0,95.0,70.0];
acpcPC=[95.0, 119.53149, 70.0];
acpcRes=1.0;
acpcDim=[192, 236, 171];

mat=[origOrient(1,1)*origRes(1)/acpcRes origOrient(1,2)*origRes(2)/acpcRes origOrient(1,3)*origRes(3)/acpcRes acpcAC(1)-origOrient(1,1)*(origAC(1))*origRes(1)/acpcRes-origOrient(1,2)*(origAC(2))*origRes(2)/acpcRes-origOrient(1,3)*(origAC(3))*origRes(3)/acpcRes;
    origOrient(2,1)*origRes(1)/acpcRes origOrient(2,2)*origRes(2)/acpcRes origOrient(2,3)*origRes(3)/acpcRes acpcAC(2)+origOrient(2,1)*(-origAC(1))*origRes(1)/acpcRes+origOrient(2,2)*(-origAC(2))*origRes(2)/acpcRes+origOrient(2,3)*(-origAC(3))*origRes(3)/acpcRes;
    origOrient(3,1)*origRes(1)/acpcRes origOrient(3,2)*origRes(2)/acpcRes origOrient(3,3)*origRes(3)/acpcRes acpcAC(3)+origOrient(3,1)*(-origAC(1))*origRes(1)/acpcRes+origOrient(3,2)*(-origAC(2))*origRes(2)/acpcRes+origOrient(3,3)*(-origAC(3))*origRes(3)/acpcRes];
    





