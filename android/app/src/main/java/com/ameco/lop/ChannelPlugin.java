package com.ameco.lop;

import android.content.Context;
import android.widget.Toast;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class ChannelPlugin implements MethodChannel.MethodCallHandler {

    private static String TAG = "ChannelPlugin";


    private static Context mContext;

    public static void registerMethodWith(PluginRegistry.Registrar registrar){
        MethodChannel methodChannel = new MethodChannel(registrar.messenger(), "plugins.com.ameco.lop/get_channel");
        ChannelPlugin instance = new ChannelPlugin();
        methodChannel.setMethodCallHandler(instance);
        mContext = registrar.context();
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (call.method.equals("getChannel")){
            String channel = mContext.getString(R.string.cId);
            result.success(channel);
        }
    }
}
