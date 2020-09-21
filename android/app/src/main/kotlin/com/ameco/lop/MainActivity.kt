package com.ameco.lop

import android.os.Bundle
import android.os.Looper
import android.widget.Toast
import androidx.core.content.ContextCompat.getSystemService
import cn.org.bjca.anysign.android.api.Interface.OnSealSignResultListener
import cn.org.bjca.anysign.android.api.core.SealSignAPI
import cn.org.bjca.anysign.android.api.core.SealSignObj
import cn.org.bjca.anysign.android.api.core.domain.AnySignBuild
import cn.org.bjca.anysign.android.api.core.domain.SealSignResult
import cn.org.bjca.anysign.android.api.core.domain.SignatureType
import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import org.json.JSONObject
import javax.swing.UIManager.put


class MainActivity: FlutterActivity() {
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)
  }

  private var mainActivity: MainActivity? = null
  private var url: String? = null
  /**
   * Returns the name of the main component registered from JavaScript.
   * This is used to schedule rendering of the component.
   */
  protected fun getMainComponentName(): String? {
    return "airlinetask"
  }

  fun MainActivity() {
    mainActivity = this
  }

  fun getMainActivity(): MainActivity? {
    return mainActivity
  }

  fun getUrl(): String? {
    return url
  }

  fun setUrl(url: String?) {
    this.url = url
  }

  private var api: SealSignAPI? = null
  private var apiResult = 0
  private var reactContext: ReactContext? = null
  private var userInfo: String? = null
  private var userId: String? = ""

  // 单签加密包
  private val obj: Any? = null
  // 批签加密包
  private var listRequest: ArrayList? = null

  /**
   * 签名API初始化
   * @param reactContext
   * @param userInfo
   */
  fun initApi(reactContext: ReactContext?, userInfo: String?) {
    if (this.reactContext == null) {
      this.reactContext = reactContext
    }
    if (this.userInfo == null) {
      this.userInfo = userInfo
    }
    var infoArr: Array<String?>? = null
    if (userInfo == null) {
      return
    } else {
      infoArr = userInfo.split(":").toTypedArray()
      userId = infoArr[0]
    }
    try { // 设置签名算法，默认为RSA，可以设置成SM2
      AnySignBuild.Default_Cert_EncAlg = "SM2"
      // 初始化API
      if (api == null) {
        api = SealSignAPI(this)
      }
      // 设置渠道号
      apiResult = api!!.setChannel("999999")
      // 渠道设置结果
      Log.e("XSS", "apiResult -- setChannel：$apiResult")
      val sealData = "原文初始化"
      apiResult = api!!.setOrigialContent(sealData.toByteArray(charset("UTF-8")))
      val signer = Signer(infoArr[1], infoArr[0], Signer.SignerCardType.TYPE_IDENTITY_CARD)
      // Signer signer = new Signer("aaa", "bbb", Signer.SignerCardType.TYPE_IDENTITY_CARD);
      val obj = SealSignObj(0, signer)
      MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", "sealData 是:$sealData")
      MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", "siner 是:" + "aaa" + "bbb" + Signer.SignerCardType.TYPE_IDENTITY_CARD)
      obj.Signer = signer
      //	设置签名规则
//obj.SignRule = signRule;
//	设置签名图片高度，单位dip
      obj.single_height = 100f
      //	设置签名图片宽度，单位dip
      obj.single_width = 100f
      //	设置签名对话框的高度，单位dip
      obj.single_dialog_height = 500
      //	设置签名对话框的宽度，单位dip
      obj.single_dialog_width = 600
      obj.IsTSS = true
      obj.nessesary = true
      obj.penColor = Color.BLACK
      apiResult = api!!.addSignatureObj(obj, SignatureType.SIGN_TYPE_SIGN)
      Log.e("XSS", "apiResult -- addSignatureObj：$apiResult")
      /*
             * 注册签名结果回调函数
             */api!!.setSealSignResultListener(object : OnSealSignResultListener {
        override fun onSignResult(signResult: SealSignResult) { // 检查是否已经准备好签名
          val readyCode = api!!.isReadyToGen
          if (readyCode != 0) {
            Toast.makeText(MainActivity.getMainActivity().reactContext, "错误代码:$readyCode", Toast.LENGTH_LONG).show()
            return
          }
          // final String base64Code = HttpUtil.bitmapToBase64(signResult.signature);
          val base64Code: String = HttpUtil.bitmapToBase64(signResult.signature).replaceAll("\r|\n", "")
          // 生成签名信息
// MainActivity.this.listRequest.clear();
          listRequest = api!!.genSignRequest(signDataList)
          // 发送加密包
          Thread(Runnable {
            try {
              val jsonObject = JSONObject()
              if (isSingle) {
                jsonObject.put("signdata", listRequest.get(0).toString())
              } else {
                val signIdArr = signId!!.split(",").toTypedArray()
                var signData = ""
                for (signId in signIdArr) {
                  for (i in 0 until signDataList.size()) {
                    val tempData = String((signDataList.get(i) as ByteArray))
                    if (tempData.contains("$signId-textInfo:")) {
                      signData = if (signData == "") {
                        signId + ":" + listRequest.get(i).toString()
                      } else {
                        signData + "-split-" + signId + ":" + listRequest.get(i).toString()
                      }
                    }
                  }
                }
                jsonObject.put("signdata", signData)
              }
              jsonObject.put("jcid", jcId)
              jsonObject.put("base64", base64Code)
              jsonObject.put("posid", posId)
              jsonObject.put("signid", signId)
              jsonObject.put("signtype", signType)
              if (userId == null) {
                MainActivity.getMainActivity().emitEvent("ErrorToRNMessage", "")
                Looper.prepare()
                Toast.makeText(MainActivity.getMainActivity().getApplicationContext(), "签名失败", Toast.LENGTH_LONG).show()
                Looper.loop()
              } else {
                jsonObject.put("userid", userId)
              }
              //String result = HttpUtil.runPost("http://192.168.0.146:8080/xmis/AirlineTaskAction/signJcData.do", jsonObject.toString());
              if (null != offlinejcdata) {
                MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", "签名完成，当前为离线模式")
                // 离线模式
                if (isSingle) {
                  MainActivity.getMainActivity().emitEvent("AndroidToRNMessageOffline", jsonObject.toString())
                  MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", jsonObject.toString())
                  MainActivity.getMainActivity().emitEvent("AndroidToRNMessage", base64Code)
                } else {
                  val json = JSONObject()
                  val signIdArr = signId!!.split(",").toTypedArray()
                  val posIdArr = posId!!.split(",").toTypedArray()
                  val sb = StringBuffer()
                  for (i in signIdArr.indices) {
                    json.put("signdata", listRequest.get(i).toString())
                    json.put("jcid", jcId)
                    json.put("base64", base64Code)
                    json.put("posid", posIdArr[i])
                    json.put("signid", signIdArr[i])
                    json.put("signtype", signType)
                    json.put("userid", userId)
                    if (i == 0) {
                      sb.append(json.toString())
                    } else {
                      sb.append("-split-")
                      sb.append(json.toString())
                    }
                  }
                  MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", "lalala$sb")
                  MainActivity.getMainActivity().emitEvent("AndroidToRNMessageOffline", sb.toString())
                  MainActivity.getMainActivity().emitEvent("AndroidToRNMessage", base64Code)
                  //                                        for(String str:signIdArr){
                  //                                            json.put("signdata", MainActivity.this.listRequest.get( 0 ).toString());
                  //                                        }
                }
              } else {
                MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", "签名完成，当前为在线模式")
                MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", jsonObject.toString())
                val result: String = HttpUtil.runPost("$url/xmis/AirlineTaskAction/signJcData.do", jsonObject.toString())
                val jsonObjectResult = JSONObject(result)
                if (jsonObjectResult["result"] == "success") { // 签名成功，返回签名图片
                  MainActivity.getMainActivity().emitEvent("AndroidToRNMessage", base64Code)
                } else {
                  MainActivity.getMainActivity().emitEvent("ErrorToRNMessage", "")
                  Looper.prepare()
                  Toast.makeText(MainActivity.getMainActivity().getApplicationContext(), "签名失败：" + jsonObjectResult["info"], Toast.LENGTH_LONG).show()
                  Looper.loop()
                }
                Log.e("tagtag", result)
              }
              // 清空离线jcdata，防止下次签名误判
              offlinejcdata = null
            } catch (e: Exception) {
              MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", e.message)
              Log.e("tagtag", e.message)
            }
          }).start()
          // 重置签名API
// MainActivity.getMainActivity().api.resetAPI();
        }

        override fun onDismiss(index: Int, signType: SignatureType) { // Log.e("XSS", "onDismiss index : " + index + "  signType : " + signType);
          MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", "onDismiss index : $index  signType : $signType")
        }

        override fun onCancel(index: Int, signType: SignatureType) { // 重置签名API
          MainActivity.getMainActivity().emitEvent("ErrorToRNMessage", "")
        }
      })
    } catch (e: Exception) {
      e.printStackTrace()
      Log.e("Exception:", e.message)
    }
  }

  /**
   * 发送事件、数据到RN
   * @param eventName
   * @param eventData
   */
  private fun emitEvent(eventName: String, eventData: String) {
    reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java).emit(eventName, eventData)
  }

  private var jcId: String? = null
  private var posId: String? = null
  private var signId: String? = null
  private var signType = "pos"
  private var isSingle = true
  private val signDataList: ArrayList = ArrayList()
  private var offlinejcdata: String? = null
  /**
   * 弹出签名框
   */
  fun show(signData: String?) {
    if (signData == null) {
      Toast.makeText(reactContext, "获取工卡数据失败！", Toast.LENGTH_LONG).show()
      return
    } else {
      val dataArr = signData.split(":").toTypedArray()
      // this.jcId = dataArr[0];
      if (dataArr[0] == "jcid") { //完工签署
        signType = "jc"
        jcId = dataArr[1]
        isSingle = true
      } else if (dataArr[0] == "date") { //日期签署
        signType = "date"
        jcId = dataArr[1]
      } else if (dataArr[0] == "posid") { //工序签署
// Toast.makeText(this.reactContext,"工序签署！",Toast.LENGTH_LONG).show();
        signType = "pos"
        jcId = dataArr[1]
        posId = dataArr[2]
        signId = dataArr[3]
        // 此处为离线版本才会传入的值 传入事先存储的jcdata
        if (dataArr.size == 5) { // hint 提示用户当前为离线签署
          Toast.makeText(reactContext, "离线签署！", Toast.LENGTH_LONG).show()
          // 将jcdata存入成员变量 方便签名时使用
          offlinejcdata = dataArr[4]
          // 给RN发log信息，用于调试
          MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", offlinejcdata)
        }
        if (dataArr[3].contains(",")) {
          isSingle = false // 批量签署
        } else {
          isSingle = true // 单个签署
        }
      }
      //另开一个线程，获取加密数据
      Thread(Runnable {
        try { // log 线程运行
          MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", "线程运行")
          if (signType != "date") {
            var result = ""
            // 若offlinejcdata不为null 说明为离线签名
            if (null != offlinejcdata) { // log 进入 离线签名 分支
              MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", "离线签名")
              // 模拟成正常请求时返回的json数据
              result = "{\"result\":\"success\",\"jcdata\":" + offlinejcdata + "}"
              // log 打印出拼出字符串是否正确
              MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", result)
            } else { // 正常的请求jcdata流程
              result = HttpUtil.runGet(url + "/xmis/AirlineTaskAction/getJcData.do?signtype=" + signType + "&jcid=" + jcId +
                      "&posid=" + posId + "&signid=" + signId + "&userid=" + userId)
            }
            MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", "获取加密数据结束")
            //String result = HttpUtil.runGet( "http://192.168.0.146:8080/xmis/AirlineTaskAction/getJcData.do?signtype=" + MainActivity.this.signType + "&jcid=" + MainActivity.this.jcId + "&posid=" + MainActivity.this.posId + "&signid=" + MainActivity.this.signId + "&userid=" + MainActivity.this.userId );
            val jsonObject = JSONObject(result)
            // 请求成功分支
            if (jsonObject.getString("result") == "success") { // log 正常运行
              MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", "加密成功运行")
              // 清除可能存在的上次残留数据
              signDataList.clear()
              // 接收过来的jcdata 带有很多%20  进行urldecode
              val jcData: String = URLDecoder.decode(jsonObject.getString("jcdata"), "UTF-8")
              if (isSingle) { // 单签
                signDataList.add(jcData.toByteArray(charset("UTF-8")))
              } else { // 批签
                val signDataArr = jcData.split("-split-").toTypedArray()
                for (signData in signDataArr) {
                  signDataList.add(signData.toByteArray(charset("UTF-8")))
                }
              }
              // MainActivity.this.initApi( MainActivity.this.reactContext, MainActivity.this.userInfo );
              if (api != null) {
                try {
                  apiResult = api!!.showSignatureDialog(0)
                  if (apiResult == SignatureAPI.SUCCESS) {
                    Log.e("result：", "成功")
                  } else {
                    Log.e("error-code：", apiResult.toString() + "")
                  }
                } catch (e: Exception) {
                  Log.e("show-exception:", e.message)
                }
              }
            } else {
              MainActivity.getMainActivity().emitEvent("ErrorToRNMessage", "")
              Looper.prepare()
              Toast.makeText(MainActivity.getMainActivity().getApplicationContext(), "签名失败：" + jsonObject["info"], Toast.LENGTH_LONG).show()
              Looper.loop()
            }
          } else {
            api!!.setOrigialContent("date".toByteArray(charset("UTF-8")))
            api!!.showSignatureDialog(0)
          }
        } catch (e: Exception) { // Toast.makeText(MainActivity.getMainActivity().getApplicationContext(), "出错啦",Toast.LENGTH_LONG).show();
          MainActivity.getMainActivity().emitEvent("AndroidToRNMessageLog", e.message)
          Log.e("tagtag", e.message)
        }
      }).start()
    }
  }

  override fun finish() {
    if (api != null) {
      api!!.finalizeAPI()
    }
    super.finish()
  }

}
