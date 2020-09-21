package com.ameco.lop;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.graphics.Color;
import android.os.Looper;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.URLDecoder;
import java.util.ArrayList;

import cn.org.bjca.anysign.android.api.Interface.OnSealSignResultListener;
import cn.org.bjca.anysign.android.api.core.SealSignAPI;
import cn.org.bjca.anysign.android.api.core.SealSignObj;
import cn.org.bjca.anysign.android.api.core.SignatureAPI;
import cn.org.bjca.anysign.android.api.core.Signer;
import cn.org.bjca.anysign.android.api.core.domain.AnySignBuild;
import cn.org.bjca.anysign.android.api.core.domain.SealSignResult;
import cn.org.bjca.anysign.android.api.core.domain.SignatureType;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.JSONMessageCodec;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StringCodec;

public class FlutterNativeSignPlugin extends FlutterActivity implements MethodChannel.MethodCallHandler {

    private static FlutterNativeSignPlugin mainActivity;
    public FlutterNativeSignPlugin() {
        mainActivity = this;
    }
    public static FlutterNativeSignPlugin getMainActivity() {
        return mainActivity;
    }
    public static String METHOD_CHANNEL = "com.ameco.lop.sign/method";
    public static String MESSAGE_CHANNEL = "com.ameco.lop.sign/message";
    static MethodChannel methodChannel;
    static BasicMessageChannel messageChannel;
    private Activity activity;
    private String url;
    private SealSignAPI api = null;
    private int apiResult;
    private String userInfo = null;
    private String userId = "";
    // 单签加密包
    private Object obj = null;
    // 批签加密包
    private ArrayList listRequest = null;
    private FlutterNativeSignPlugin(Activity activity) {
        this.activity = activity;
    }
    public static void registerMethodWith(Registrar registrar){
        methodChannel = new MethodChannel(registrar.messenger(), METHOD_CHANNEL);
        FlutterNativeSignPlugin instance = new FlutterNativeSignPlugin(registrar.activity());
        mainActivity = instance;
        methodChannel.setMethodCallHandler(instance);
    }
    public static void registerMessageWith(Registrar registrar){
        messageChannel = new BasicMessageChannel(registrar.messenger(), MESSAGE_CHANNEL, JSONMessageCodec.INSTANCE);
    }
    @Override
    public void onMethodCall( MethodCall methodCall, MethodChannel.Result result) {
        if (methodCall.method.equals("initUrl")){
            url = (String) methodCall.arguments;
            result.success(true);
        }
        if (methodCall.method.equals("initApi")) {
            initApi((String) methodCall.arguments);
            result.success(true);
        }
        if(methodCall.method.equals("show")){
            show((String) methodCall.arguments);
            result.success(true);
        }
        if(methodCall.method.equals("deleteSign")){
            this.emitEvent("AndroidDeleteSign", (String) methodCall.arguments);
            result.success(true);
        }
        if ((methodCall.method.equals("toastShow"))){
            Toast.makeText(activity,(String) methodCall.arguments,Toast.LENGTH_LONG).show();
            result.success(true);
        }
    }
    @Override
    public void finish() {
        if(api != null){
            api.finalizeAPI();
        }
        super.finish();
    }
    /**
     * 签名API初始化
     * @param userInfo
     */
    public void initApi( String userInfo){
        if(this.userInfo == null){
            this.userInfo = userInfo;
        }
        String[] infoArr = null;
        if(userInfo == null){
            return;
        }else{
            infoArr = userInfo.split(":",-1);
            this.userId = infoArr[0];
        }
        try{
            // 设置签名算法，默认为RSA，可以设置成SM2
            AnySignBuild.Default_Cert_EncAlg = "SM2";
            // 初始化API
            if(api == null){
                api = new SealSignAPI(activity);
            }
            // 设置渠道号
            apiResult = api.setChannel("999999");
            // 渠道设置结果
            Log.e("XSS", "apiResult -- setChannel：" + apiResult);
            final String sealData = "原文初始化";
            apiResult = api.setOrigialContent(sealData.getBytes("UTF-8"));
            Signer signer = new Signer(infoArr[1], infoArr[0], Signer.SignerCardType.TYPE_IDENTITY_CARD);
            // Signer signer = new Signer("aaa", "bbb", Signer.SignerCardType.TYPE_IDENTITY_CARD);
            SealSignObj obj = new SealSignObj(0,signer);
            //this.emitEvent("AndroidToRNMessageLog", "sealData 是:" + sealData);
            //this.emitEvent("AndroidToRNMessageLog", "siner 是:" + "aaa" + "bbb" + Signer.SignerCardType.TYPE_IDENTITY_CARD);
            obj.Signer = signer;
            //	设置签名规则
            //obj.SignRule = signRule;
            //	设置签名图片高度，单位dip
            obj.single_height = 100;
            //	设置签名图片宽度，单位dip
            obj.single_width = 100;
            //	设置签名对话框的高度，单位dip
            obj.single_dialog_height = 500;
            //	设置签名对话框的宽度，单位dip
            obj.single_dialog_width = 600;
            obj.IsTSS = true;
            obj.nessesary = true;
            obj.penColor = Color.BLACK;
            apiResult = api.addSignatureObj(obj, SignatureType.SIGN_TYPE_SIGN);
            Log.e("XSS", "apiResult -- addSignatureObj：" + apiResult);
            /*
             * 注册签名结果回调函数
             */
            api.setSealSignResultListener(new OnSealSignResultListener() {
                @Override
                public void onSignResult(SealSignResult signResult)
                {
                    // 检查是否已经准备好签名
                    int readyCode = api.isReadyToGen();
                    if(readyCode != 0){
                        Toast.makeText(activity,"错误代码:" + readyCode,Toast.LENGTH_LONG).show();
                        return;
                    }
                    // final String base64Code = HttpUtil.bitmapToBase64(signResult.signature);
                    final String base64Code = HttpUtil.bitmapToBase64(signResult.signature).replaceAll("\r|\n", "");;
                    // 生成签名信息
                    // MainActivity.this.listRequest.clear();
                    FlutterNativeSignPlugin.this.listRequest = api.genSignRequest( FlutterNativeSignPlugin.this.signDataList );
                    // 发送加密包
                    new Thread( new Runnable() {
                        @Override
                        public void run() {
                            try{
                                JSONObject jsonObject = new JSONObject();
                                if(FlutterNativeSignPlugin.this.isSingle){
//                                    jsonObject.put("compress", false);
//                                    jsonObject.put("signdata", HttpUtil.compress(FlutterNativeSignPlugin.this.listRequest.get( 0 ).toString()));
                                    jsonObject.put("signdata", FlutterNativeSignPlugin.this.listRequest.get( 0 ).toString());
                                }else{
                                    String[] signIdArr = FlutterNativeSignPlugin.this.signId.split( "," );
                                    String signData = "";
                                    for(String signId:signIdArr){
                                        for(int i=0;i<FlutterNativeSignPlugin.this.signDataList.size();i++){
                                            String tempData = new String((byte[]) FlutterNativeSignPlugin.this.signDataList.get( i ));
                                            if(tempData.contains( signId+"-textInfo:" )){
                                                if(signData.equals( "" )){
                                                    signData = signId + ":" + FlutterNativeSignPlugin.this.listRequest.get( i ).toString();
                                                }else {
                                                    signData = signData + "-split-" + signId + ":" + FlutterNativeSignPlugin.this.listRequest.get( i ).toString();
                                                }

                                            }
                                        }
                                    }
//                                    jsonObject.put("compress", true);
//                                    jsonObject.put( "signdata",HttpUtil.compress(signData));
                                    jsonObject.put( "signdata",signData);
                                }
                                jsonObject.put("jcid", FlutterNativeSignPlugin.this.jcId);
                                jsonObject.put( "base64", base64Code );
                                jsonObject.put("posid",FlutterNativeSignPlugin.this.posId);
                                jsonObject.put("signid", FlutterNativeSignPlugin.this.signId);
                                jsonObject.put("signtype", FlutterNativeSignPlugin.this.signType);
                                if(FlutterNativeSignPlugin.this.userId == null){
                                    FlutterNativeSignPlugin.getMainActivity().emitEvent("ErrorToRNMessage", "");
                                    Looper.prepare();
                                    Toast.makeText(activity,"签名失败",Toast.LENGTH_LONG).show();
                                    Looper.loop();
                                }else{
                                    jsonObject.put("userid", FlutterNativeSignPlugin.this.userId);
                                }
                                //String result = HttpUtil.runPost("http://192.168.0.146:8080/xmis/AirlineTaskAction/signJcData.do", jsonObject.toString());
                                if(null != FlutterNativeSignPlugin.this.offlinejcdata){
                                  //  MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", "签名完成，当前为离线模式");
                                    // 离线模式
                                    if(FlutterNativeSignPlugin.this.isSingle){
                                       // MainActivity.getMainActivity().emitEvent("AndroidToRNMessageOffline", jsonObject.toString());
                                       // MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", jsonObject.toString());
                                       // MainActivity.getMainActivity().emitEvent("AndroidToRNMessage", base64Code);
                                    }else {
                                        JSONObject json = new JSONObject();
                                        String[] signIdArr = FlutterNativeSignPlugin.this.signId.split( "," );
                                        String[] posIdArr = FlutterNativeSignPlugin.this.posId.split( "," );
                                        StringBuffer sb = new StringBuffer();
                                        for(int i =0;i<signIdArr.length;i++){
                                            json.put("signdata", FlutterNativeSignPlugin.this.listRequest.get( i ).toString());
                                            json.put("jcid", FlutterNativeSignPlugin.this.jcId);
                                            json.put( "base64", base64Code );
                                            json.put("posid",posIdArr[i]);
                                            json.put("signid", signIdArr[i]);
                                            json.put("signtype", FlutterNativeSignPlugin.this.signType);
                                            json.put("userid", FlutterNativeSignPlugin.this.userId);
                                            if(i==0){
                                                sb.append(json.toString());
                                            }else{
                                                sb.append("-split-");
                                                sb.append(json.toString());
                                            }
                                        }
                                       // MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", "lalala"+sb.toString());
                                       // MainActivity.getMainActivity().emitEvent("AndroidToRNMessageOffline", sb.toString());
                                       // MainActivity.getMainActivity().emitEvent("AndroidToRNMessage", base64Code);
//                                        for(String str:signIdArr){
//                                            json.put("signdata", MainActivity.this.listRequest.get( 0 ).toString());
//                                        }
                                    }
                                }else {
                                    FlutterNativeSignPlugin.getMainActivity().emitEvent("AndroidToRNMessageLog", "签名完成，当前为在线模式");
                                    FlutterNativeSignPlugin.getMainActivity().emitEvent("AndroidToRNMessageLog", jsonObject.toString());
                                    System.out.println("输出时间:Android 开始上传加密信息object:"+System.currentTimeMillis());
                                    String result = HttpUtil.runPost(url + "AirlineTaskAction/signJcData.do", jsonObject.toString());
                                    //TODO:输出时间 结束上传加密信息
                                    System.out.println("输出时间:Android 结束上传加密信息object:"+System.currentTimeMillis());
                                    JSONObject jsonObjectResult = new JSONObject(result);
                                    if(jsonObjectResult.get( "result" ).equals( "success" )){
                                        // 签名成功，返回签名图片
                                        //Log.e("base64:",base64Code);
                                        FlutterNativeSignPlugin.getMainActivity().emitEvent("AndroidToRNMessage", base64Code);
                                    }else{
                                        FlutterNativeSignPlugin.getMainActivity().emitEvent("ErrorToRNMessage", "");
                                        Looper.prepare();
                                        Toast.makeText(activity,"签名失败：" +  jsonObjectResult.get( "info" ),Toast.LENGTH_LONG).show();
                                        Looper.loop();
                                    }
                                    //Log.e("tagtag", result);
                                }
                                // 清空离线jcdata，防止下次签名误判
                                FlutterNativeSignPlugin.this.offlinejcdata = null;
                            }catch (Exception e){
                                FlutterNativeSignPlugin.getMainActivity().emitEvent("AndroidToRNMessageLog", e.getMessage());
                                Log.e("tagtag", e.getMessage());
                            }
                        }
                    } ).start();
                    // 重置签名API
                    // MainActivity.getMainActivity().api.resetAPI();
                }
                @Override
                public void onDismiss(int index, SignatureType signType)
                {
                    //Log.e("XSS", "onDismiss index : " + index + "  signType : " + signType);
                    FlutterNativeSignPlugin.getMainActivity().emitEvent("AndroidToRNMessageLog", "onDismiss index : " + index + "  signType : " + signType);
                }

                @Override
                public void onCancel(int index, SignatureType signType)
                {
                    Log.e("onCancel", "onCancel");
                    // 重置签名API
                    FlutterNativeSignPlugin.getMainActivity().emitEvent("ErrorToRNMessage", "");
                }
            });

        }catch (Exception e){
            Toast.makeText(activity,e.getMessage(),Toast.LENGTH_LONG).show();
            e.printStackTrace();
            Log.e("Exception:", e.getMessage());
        }
    }
    /**
     * 发送事件、数据到Flutter
     * @param eventName
     * @param eventData
     */
    private void emitEvent(String eventName, String eventData) {
        try {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("eventName",eventName);
            jsonObject.put("eventData",eventData);
            FlutterNativeSignPlugin.getMainActivity().runOnUiThread(()->{
                messageChannel.send(jsonObject.toString());
            });

        }catch (Exception e){
            Log.e("jsonObj",e.getMessage());
        }
        // this.reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit(eventName, eventData);
    }
    private String jcId = null;
    private String posId = null;
    private String signId = null;
    private String signType = "pos";
    private Boolean isSingle = true;
    private ArrayList signDataList=new ArrayList<>();
    private String offlinejcdata = null;
    /**
     * 弹出签名框
     */
    public void show(String signData){
        if(signData == null) {
            Toast.makeText(activity,"获取工卡数据失败！",Toast.LENGTH_LONG).show();
            return;
        }else{
            String[] dataArr = signData.split(":");
            // this.jcId = dataArr[0];
            if(dataArr[0].equals( "jcid" )){       //完工签署
                this.signType="jc";
                this.jcId = dataArr[1];
                this.isSingle = true;
            }else if(dataArr[0].equals("date")){   //日期签署
                this.signType="date";
                this.jcId = dataArr[1];
            }else if(dataArr[0].equals("posid")){  //工序签署
                 //Toast.makeText(activity,"工序签署！",Toast.LENGTH_LONG).show();
                this.signType="pos";
                this.jcId = dataArr[1];
                this.posId = dataArr[2];
                this.signId = dataArr[3];
                FlutterNativeSignPlugin.this.emitEvent("AndroidToRNMessageLog", this.offlinejcdata);
                // 此处为离线版本才会传入的值 传入事先存储的jcdata
                if(dataArr.length==5){
                    // hint 提示用户当前为离线签署
                    Toast.makeText(activity,"离线签署！",Toast.LENGTH_LONG).show();
                    // 将jcdata存入成员变量 方便签名时使用
                    this.offlinejcdata = dataArr[4];
                    // 给RN发log信息，用于调试
                    FlutterNativeSignPlugin.this.emitEvent("AndroidToRNMessageLog", this.offlinejcdata);
                }
                if (dataArr[3].contains( "," )){
                    this.isSingle = false;        // 批量签署
                }else{
                    this.isSingle = true;         // 单个签署
                }
            }
            //另开一个线程，获取加密数据
            new Thread( new Runnable() {
                @Override
                public void run() {
                    try{
                        // log 线程运行
                        FlutterNativeSignPlugin.this.emitEvent("AndroidToRNMessageLog", "线程运行");
                        if(!FlutterNativeSignPlugin.this.signType.equals( "date" )) {
                            String result = "";
                            // 若offlinejcdata不为null 说明为离线签名
                            if(null!=FlutterNativeSignPlugin.this.offlinejcdata){
                                // log 进入 离线签名 分支
                                FlutterNativeSignPlugin.this.emitEvent("AndroidToRNMessageLog", "离线签名");
                                // 模拟成正常请求时返回的json数据
                                result = "{\"result\":\"success\",\"jcdata\":"+FlutterNativeSignPlugin.this.offlinejcdata+"}";
                                // log 打印出拼出字符串是否正确
                                FlutterNativeSignPlugin.this.emitEvent("AndroidToRNMessageLog", result);
                            }else{
                                // 正常的请求jcdata流程
                                result = HttpUtil.runGet(url + "AirlineTaskAction/getJcData.do?signtype=" + FlutterNativeSignPlugin.this.signType + "&jcid="+FlutterNativeSignPlugin.this.jcId+
                                        "&posid="+FlutterNativeSignPlugin.this.posId+"&signid="+FlutterNativeSignPlugin.this.signId+"&userid="+FlutterNativeSignPlugin.this.userId);
                            }
                            FlutterNativeSignPlugin.this.emitEvent("AndroidToRNMessageLog", "获取加密数据结束");
                            //String result = HttpUtil.runGet( "http://192.168.0.146:8080/xmis/AirlineTaskAction/getJcData.do?signtype=" + MainActivity.this.signType + "&jcid=" + MainActivity.this.jcId + "&posid=" + MainActivity.this.posId + "&signid=" + MainActivity.this.signId + "&userid=" + MainActivity.this.userId );
                            JSONObject jsonObject = new JSONObject(result );
                            // 请求成功分支
                            if (jsonObject.getString( "result" ).equals( "success" )) {
                                // log 正常运行
                                FlutterNativeSignPlugin.this.emitEvent("AndroidToRNMessageLog", "加密成功运行");
                                // 清除可能存在的上次残留数据
                                FlutterNativeSignPlugin.this.signDataList.clear();
                                // 接收过来的jcdata 带有很多%20  进行urldecode
                                String jcData = URLDecoder.decode( jsonObject.getString( "jcdata" ), "UTF-8" );
                                if(FlutterNativeSignPlugin.this.isSingle) { // 单签
                                    FlutterNativeSignPlugin.this.signDataList.add( jcData.getBytes( "UTF-8" ) );
                                }else{                           // 批签
                                    String[] signDataArr=jcData.split( "-split-" );
                                    for(String signData:signDataArr){
                                        FlutterNativeSignPlugin.this.signDataList.add( signData.getBytes( "UTF-8" ) );
                                    }
                                }
                                // MainActivity.this.initApi( MainActivity.this.reactContext, MainActivity.this.userInfo );
                                if (api != null) {
                                    try {
                                        apiResult = api.showSignatureDialog( 0 );
                                        if (apiResult == SignatureAPI.SUCCESS) {
                                            Log.e( "result：", "成功" );
                                        } else {
                                            Log.e( "error-code：", apiResult + "" );
                                        }
                                    } catch (Exception e) {
                                        Log.e( "show-exception:", e.getMessage() );
                                    }
                                }
                            } else {
                                FlutterNativeSignPlugin.this.emitEvent("ErrorToRNMessage", "");
                                Looper.prepare();
                                Toast.makeText( activity, "签名失败：" + jsonObject.get( "info" ), Toast.LENGTH_LONG ).show();
                                Looper.loop();
                            }
                        }else {
                            api.setOrigialContent( "date".getBytes("UTF-8") );
                            api.showSignatureDialog( 0 );
                        }
                    }catch (Exception e){
                        // Toast.makeText(MainActivity.getMainActivity().getApplicationContext(), "出错啦",Toast.LENGTH_LONG).show();
                        FlutterNativeSignPlugin.this.emitEvent("AndroidToRNMessageLog", e.getMessage());
                        Log.e("tagtag", e.getMessage());
                    }
                }
            } ).start();
        }
    }
}
