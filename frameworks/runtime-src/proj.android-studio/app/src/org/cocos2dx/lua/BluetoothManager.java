package org.cocos2dx.lua;

import android.app.Activity;
import android.app.AlertDialog;
import android.bluetooth.BluetoothDevice;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import com.devpaul.bluetoothutillib.SimpleBluetooth;
import com.devpaul.bluetoothutillib.dialogs.DeviceDialog;
import com.devpaul.bluetoothutillib.utils.BluetoothUtility;
import com.devpaul.bluetoothutillib.utils.SimpleBluetoothListener;

/**
 * Created by liubo on 16/5/24.
 */
public class BluetoothManager {
    private Context context;

    private static BluetoothManager bluetoothManager;
    private SimpleBluetooth simpleBluetooth;

    private static final int SCAN_REQUEST = 119;
    private static final int CHOOSE_SERVER_REQUEST = 120;

    private String curMacAddress;


    private void initBluetooth() {
        if (simpleBluetooth == null) {
            simpleBluetooth = new SimpleBluetooth(context, new SimpleBluetoothListener() {
                @Override
                public void onBluetoothDataReceived(byte[] bytes, String data) {
                    //read the data coming in.
                    Toast.makeText(context, "Data: " + data, Toast.LENGTH_SHORT).show();

                    onDataReceived(data);
                    Log.w("SIMPLEBT", "Data received");
                }

                @Override
                public void onDeviceConnected(BluetoothDevice device) {
                    //a device is connected so you can now send stuff to it
                    Toast.makeText(context, "Connected!", Toast.LENGTH_SHORT).show();
                    Log.w("SIMPLEBT", "Device connected");
                }

                @Override
                public void onDeviceDisconnected(BluetoothDevice device) {
                    // device was disconnected so connect it again?
                    Toast.makeText(context, "Disconnected!", Toast.LENGTH_SHORT).show();
                    Log.w("SIMPLEBT", "Device disconnected");
                }
            });
        }
    }

    private void useBluetooth(){
        if (simpleBluetooth != null) {
            simpleBluetooth.makeDiscoverable(300); //可被发现模式
            simpleBluetooth.initializeSimpleBluetooth();
            simpleBluetooth.setInputStreamType(BluetoothUtility.InputStreamType.BUFFERED);
        }
    }

    //在 activity 的onResume 方法中调用
    protected void onResume() {
        /*
        * this check needs to be here to ensure that the simple bluetooth is not reset.
        * an issue was occuring when a client would connect to a server. When a client
        * connects they have to select a device, that is another activity, so after they
        * select a device, this gets called again and the reference to the original simpleBluetooth
        * object on the client side gets lost. Thus when send is called, nothing happens because it's
        * a different object.
        */

        initBluetooth();
    }

    //在 activity 的 onActivityResult 方法中调用
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        if(requestCode == SCAN_REQUEST || requestCode == CHOOSE_SERVER_REQUEST) {

            if(resultCode == Activity.RESULT_OK) {

                curMacAddress = data.getStringExtra(DeviceDialog.DEVICE_DIALOG_DEVICE_ADDRESS_EXTRA);
                boolean paired = simpleBluetooth.getBluetoothUtility()
                        .checkIfPaired(simpleBluetooth.getBluetoothUtility()
                                .findDeviceByMacAddress(curMacAddress));
                String message = paired ? "is paired" : "is not paired";
                Log.i("ActivityResult", "Device " + message);
                if(requestCode == SCAN_REQUEST) {
                    simpleBluetooth.connectToBluetoothDevice(curMacAddress);
                } else {
                    simpleBluetooth.connectToBluetoothServer(curMacAddress);
                }

            }
        }
    }

    //在 activity 的 onDestroy 方法中调用
    protected void onDestroy() {
        simpleBluetooth.endSimpleBluetooth();
    }

    public static BluetoothManager getInstance(){
        System.out.print("bluetoothManager getInstance");
        if (bluetoothManager == null){
            bluetoothManager = new BluetoothManager();
        }

        return bluetoothManager;
    }

    public void init(final Context context){
        this.context = context;
    }

    //----------- C++ 调用 ------------

    private Handler searchBleAndConnectHandler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(Message message) {
            initBluetooth();
            useBluetooth();

            //弹出创建server 或者 连接server的对话框
            AlertDialog.Builder builder = new AlertDialog.Builder(context);
            //    指定下拉列表的显示数据
            final String[] choose = {"创建游戏", "加入游戏"};
            //    设置一个下拉的列表选择项
            builder.setItems(choose, new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    if (choose[which].equals("创建游戏") && simpleBluetooth != null) {
                        simpleBluetooth.createBluetoothServerConnection();

                    } else if (choose[which].equals("加入游戏") && simpleBluetooth != null) {
                        if (curMacAddress != null) {
                            simpleBluetooth.connectToBluetoothServer(curMacAddress);
                        } else {
                            simpleBluetooth.scan(CHOOSE_SERVER_REQUEST);
                        }
                    }

                }
            });
            builder.show();
            return false;
        }
    });

    private Handler sendMessageHandler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(Message message) {
            String data = message.obj.toString();
            Toast.makeText(context, data, Toast.LENGTH_SHORT).show();
            if (simpleBluetooth != null){
                simpleBluetooth.sendData(data);
            }
            return false;
        }
    });

    private Handler closeConnectedHandler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(Message message) {
            if (simpleBluetooth != null) {
                simpleBluetooth.cancelScan();
                simpleBluetooth.endSimpleBluetooth();
            }
            return false;
        }
    });


    //-------------[ call in c++ ]---------------

    public void searchBleAndConnect(){
        Message message = Message.obtain(searchBleAndConnectHandler);
        message.sendToTarget();
    }

    public void sendMessage(String message){
        Message msg = Message.obtain(sendMessageHandler);
        msg.obj = message;
        msg.sendToTarget();
    }

    public void closeConnected(){
        Message message = Message.obtain(closeConnectedHandler);
        message.sendToTarget();

    }


    native public void onDataReceived(String data);
}
