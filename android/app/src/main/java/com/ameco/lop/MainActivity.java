package com.ameco.lop;
import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        registerCustomPlugin(this);
        UpdateVersionPlugin.registerWith(registrarFor("com.ameco.lop/update_version"));
        ChannelPlugin.registerMethodWith(registrarFor("com.ameco.lop/get_channel"));
    }

    private void registerCustomPlugin(PluginRegistry registrar) {
        FlutterNativeSignPlugin.registerMethodWith(registrar.registrarFor(FlutterNativeSignPlugin.METHOD_CHANNEL));
        FlutterNativeSignPlugin.registerMessageWith(registrar.registrarFor(FlutterNativeSignPlugin.MESSAGE_CHANNEL));
    }

}
