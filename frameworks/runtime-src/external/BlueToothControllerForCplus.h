//
//  BlueToothControllerForCplusplus.h
//  BlueTooth
//
//  Created by LIUBO on 15/9/24.
//
//

class BlueToothControllerForCplus{
public:
    static BlueToothControllerForCplus * getInstance();

    void getConnect();
    void closeConnect();

    void sendMessage(const char * message);
    const char* getMessage();
};
