package com.ameco.lop;

import android.Manifest;
import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.Settings;
import android.util.Log;
import android.widget.Toast;

import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;
import androidx.core.content.FileProvider;
import androidx.core.content.PermissionChecker;

import com.king.app.updater.AppUpdater;
import com.king.app.updater.callback.UpdateCallback;


import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;

import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** UpdateVersionPlugin */
@SuppressWarnings("unchecked")
public class UpdateVersionPlugin implements EventChannel.StreamHandler, PluginRegistry.RequestPermissionsResultListener
        , PluginRegistry.ActivityResultListener, ActivityAware {

    private static String TAG = "UpdateVersionPlugin";
    private Context context;
    private Activity activity;
    private AppUpdater update;
    private EventChannel channel;
    private FlutterPlugin.FlutterPluginBinding flutterPluginBinding;
    private static final int REQUEST_CODE = 33432;
    private static final int RESULT_CODE = 0x12;
    private static final String TYPE_STRING_APK = "application/vnd.android.package-archive";
    //  private String filePath;
    private File mFile;
    /** Plugin registration. */
    public static void registerWith(Registrar registrar) {
        UpdateVersionPlugin plugin = new UpdateVersionPlugin();
        plugin.activity = registrar.activity();
        plugin.context = registrar.context();
        //plugin.filePath = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).getAbsolutePath();
        System.out.println("activity："+plugin.activity);
        plugin.channel = new EventChannel(registrar.messenger(), "plugins.com.ameco.lop/update_version");
        plugin.channel.setStreamHandler(plugin);
        registrar.addRequestPermissionsResultListener(plugin);
        registrar.addActivityResultListener(plugin);
    }


    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {

        if (o.toString().length() < 5) {
            eventSink.error(TAG, "URL错误", o);
            return;
        }
        if (!o.toString().startsWith("http")){
            eventSink.error(TAG, "URL错误", o);
            return;
        }
        update = new AppUpdater(context,o.toString(), Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS).getAbsolutePath(),false).setUpdateCallback(new UpdateCallback() {

            Map data = new HashMap<String, Object>();

            // 发送数据到 Flutter
            private  void sendData() {
                eventSink.success(data);
            }

            @Override
            public void onDownloading(boolean isDownloading) {

            }

            @Override
            public void onStart(String url) {
                data.put("start", true);
                data.put("cancel", false);
                data.put("done",false );
                data.put("error", false);
                data.put("percent", 1);
                sendData();
            }

            @Override
            public void onProgress(long progress, long total, boolean isChange) {
                int percent = (int)(progress * 1.0 / total * 100);
                if (isChange && percent > 0) {
                    data.put("percent", percent);
                    sendData();
                }
            }

            @Override
            public void onFinish(File file) {
                data.put("done", true);
                data.put("percent", 100);
                sendData();
                mFile = file;
                if (pathRequiresPermission(file)) {
                    if (hasPermission(Manifest.permission.READ_EXTERNAL_STORAGE)) {
//                    openApkFile(file);
                        checkAndroidO();
                    } else {
                        ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.READ_EXTERNAL_STORAGE}, REQUEST_CODE);
                    }
                } else {
//                openApkFile(file);
                    checkAndroidO();
                }
            }

            @Override
            public void onError(Exception e) {
                data.put("error", true);
                data.put("errorMsg", e.toString());
                sendData();
            }

            @Override
            public void onCancel() {
                data.put("cancel", true);
                sendData();
            }
        });
        update.start();
    }

    @Override
    public void onCancel(Object o) {
        Log.i(TAG, "取消下载");
        if(update != null) {
            update.stop();
        }
    }
    private boolean hasPermission(String permission) {
        return ContextCompat.checkSelfPermission(activity, permission) == PermissionChecker.PERMISSION_GRANTED;
    }
    private boolean pathRequiresPermission(File file) {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return false;
        }
        try {
            String appDirCanonicalPath = new File(context.getApplicationInfo().dataDir).getCanonicalPath();
            String fileCanonicalPath = file.getCanonicalPath();
            return !fileCanonicalPath.startsWith(appDirCanonicalPath);
        } catch (IOException e) {
            e.printStackTrace();
            return true;
        }
    }


    private void startActivity(File file) {
        if (!file.exists()) {
            Toast.makeText(activity,"the apk file is not exists",Toast.LENGTH_LONG).show();
            return;
        }
//        Intent intent = new Intent(Intent.ACTION_VIEW);
//        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
//            String packageName = context.getPackageName();
//            Uri uri = FileProvider.getUriForFile(context, packageName + ".fileProvider", file);
//            intent.setDataAndType(uri, TYPE_STRING_APK);
//        } else {
//            intent.setDataAndType(Uri.fromFile(file), TYPE_STRING_APK);
//        }
//        Intent intent;
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
//            //AUTHORITY NEEDS TO BE THE SAME ALSO IN MANIFEST
//            String packageName = context.getPackageName();
//            Uri apkUri = FileProvider.getUriForFile(context, packageName + ".fileProvider", file);
//            intent = new Intent(Intent.ACTION_INSTALL_PACKAGE);
//            intent.setDataAndType(apkUri,"application/vnd.android.package-archive");
//            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
//                    .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//        } else {
//            intent = new Intent(Intent.ACTION_VIEW);
//            intent.setDataAndType(Uri.fromFile(file), "application/vnd.android.package-archive");
//            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//        }
        Intent intentUpdate = new Intent("android.intent.action.VIEW");
        intentUpdate.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {  //对Android N及以上的版本做判断
            Uri apkUriN = FileProvider.getUriForFile(context,
                    context.getPackageName() + ".fileProvider", file);
            intentUpdate.addCategory("android.intent.category.DEFAULT");
            intentUpdate.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);  // 表示我们需要什么权限
            intentUpdate.setDataAndType(apkUriN, "application/vnd.android.package-archive");
        } else {
            Uri apkUri = Uri.fromFile(file);
            intentUpdate.setDataAndType(apkUri, "application/vnd.android.package-archive");
        }
        try {
            activity.startActivity(intentUpdate);
        } catch (ActivityNotFoundException e) {
            Toast.makeText(activity,"No APP found to open this file。",Toast.LENGTH_LONG).show();
        } catch (Exception e) {
            Toast.makeText(activity,"File opened incorrectly。",Toast.LENGTH_LONG).show();
        }
    }
    private void openApkFile(File file) {
        if (!canInstallApk()) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                startInstallPermissionSettingActivity();
            } else {
                ActivityCompat.requestPermissions(activity,
                        new String[]{Manifest.permission.REQUEST_INSTALL_PACKAGES}, REQUEST_CODE);
            }
        } else {
            startActivity(file);
        }
    }
    private void checkAndroidO() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) { //系统 Android O及以上版本
            //是否需要处理未知应用来源权限。 true为用户信任安装包安装 false 则需要获取授权
            boolean canRequestPackageInstalls = activity.getPackageManager().canRequestPackageInstalls();
            if (canRequestPackageInstalls) {
                startActivity(mFile);
            } else {
                //请求安装未知应用来源的权限
                ActivityCompat.requestPermissions(activity, new String[]{Manifest.permission.REQUEST_INSTALL_PACKAGES}, REQUEST_CODE);
            }
        } else {  //直接安装流程
            startActivity(mFile);
        }
    }
    private boolean canInstallApk() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            return activity.getPackageManager().canRequestPackageInstalls();
        }
        return hasPermission(Manifest.permission.REQUEST_INSTALL_PACKAGES);
    }

    private void startInstallPermissionSettingActivity() {
        if (activity == null) {
            return;
        }
        Uri packageURI = Uri.parse("package:" + activity.getPackageName());
        Intent intent = new Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES, packageURI);
        activity.startActivityForResult(intent, RESULT_CODE);
    }
    @Override
    public boolean onRequestPermissionsResult(int requestCode, String[] strings, int[] grantResults) {
        System.out.println("onRequestPermissionsResult requestCode:"+requestCode);
        if (requestCode != REQUEST_CODE) return false;
//        if (hasPermission(Manifest.permission.READ_EXTERNAL_STORAGE)) {
//            openApkFile(mFile);
//            return false;
//        }
//        for (int i = 0; i < strings.length; i++) {
//            if (!hasPermission(strings[i])) {
//                Toast.makeText(activity,"Permission denied: " + strings[i],Toast.LENGTH_LONG).show();
//                return false;
//            }
//        }
//        startActivity(mFile);
        if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {  //如果已经有这个权限 则直接安装 否则跳转到授权界面
            startActivity(mFile);
        } else {
            startInstallPermissionSettingActivity();
        }
        return true;
    }
    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        System.out.println("onActivityResult requestCode:"+requestCode+" resultCode:"+resultCode);
        if (requestCode == RESULT_CODE) {
            if (canInstallApk()) {
                startActivity(mFile);
            } else {
                Toast.makeText(activity,"Permission denied: " + Manifest.permission.REQUEST_INSTALL_PACKAGES,Toast.LENGTH_LONG).show();
            }
        }
        return false;
    }


    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        channel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "plugins.com.ameco.lop/update_version");
        context = flutterPluginBinding.getApplicationContext();
        activity = binding.getActivity();
        channel.setStreamHandler(this);
        binding.addRequestPermissionsResultListener(this);
        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        if (channel == null) {
            // Could be on too low of an SDK to have started listening originally.
            return;
        }
        channel.setStreamHandler(null);
        channel = null;
    }
}
