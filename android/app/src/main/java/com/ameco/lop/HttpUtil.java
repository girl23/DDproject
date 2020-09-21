package com.ameco.lop;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Environment;
import android.util.Base64;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.SocketTimeoutException;
import java.util.Iterator;
import java.util.concurrent.TimeUnit;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;


import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;


public class HttpUtil {

    private static OkHttpClient okHttpClient = new OkHttpClient().newBuilder()
            .connectTimeout( 300, TimeUnit.SECONDS )
            .readTimeout( 300, TimeUnit.SECONDS )
            .writeTimeout(300, TimeUnit.SECONDS )
            .build();
    public static final MediaType jsonType = MediaType.parse("application/json");
    /**
     * GET请求
     * @param url
     * @return
     * @throws Exception
     */
    public static String runGet(String url)throws Exception{
        Request request = new Request.Builder()
                .addHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8")
                .url(url)
                .build();
        try{
            return okHttpClient.newCall(request).execute().body().string();
        }catch (Exception e){
            return "fail" + e.getMessage();
        }
    }
    /**
     * POST请求
     * @param url
     * @param data
     * @return
     * @throws Exception
     */
    public static String runPost(String url, String data)throws Exception{
        RequestBody requestBody = RequestBody.create(jsonType, data);
        Request request = new Request.Builder()
                .url(url)
                .post(requestBody)
                .build();
        try{
            return okHttpClient.newCall(request).execute().body().string();
        }catch (Exception e){
            return "fail" + e.getMessage();
        }
    }
    /**
     * 上传文件
     * @param fileInfo
     * @return
     * @throws Exception
     */
    public static String uploadFiles(String fileInfo, String url)throws Exception{
        // [0]: 文件路径；[1]: 文件类型
        String[] fileInfoArr = fileInfo.split( ";" );
        MultipartBody.Builder requestBody = new MultipartBody.Builder().setType(MultipartBody.FORM);
        String filePath = fileInfoArr[0];
        if(null != fileInfoArr[2] && !"".equals(fileInfoArr[2]) && Long.parseLong(fileInfoArr[2]) > 1 * 1024 * 1024){   //大于1M就压缩图片
            filePath = compressPic(filePath);
        }
        File file = new File(filePath);
        if(file != null){
            // MediaType.parse() 里面是上传的文件类型。
            RequestBody body = RequestBody.create(MediaType.parse(fileInfoArr[1]), file);
            String filename = file.getName();
            // 参数分别为， 请求key ，文件名称 ， RequestBody
            requestBody.addFormDataPart("file", filename, body)
                    .addFormDataPart("type", fileInfoArr[1])
                    .addFormDataPart( "size", file.length() + "")
                    .addFormDataPart( "userid", fileInfoArr[3])
                    .addFormDataPart( "taskid", fileInfoArr[4] )
                    .addFormDataPart( "jcid", fileInfoArr[5] );
        }

        Request request = new Request.Builder()
                .url(url)
                .post(requestBody.build())
                .build();

//        try{
            return okHttpClient.newCall(request).execute().body().string();
//        }catch(SocketTimeoutException e){
//            okHttpClient.dispatcher().cancelAll();
//            okHttpClient.connectionPool().evictAll();
//            e.printStackTrace();
//            return okHttpClient.newCall(request).execute().body().string();
//        }
        /*
        okHttpClient.newBuilder().readTimeout(60000, TimeUnit.MILLISECONDS).build().newCall(request).enqueue( new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {

            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
                return response.body().string();

            }
        });

        return "";
        */
    }
    /**
     * bitmap转base64
     * @param bitmap
     * @return
     */
    public static String bitmapToBase64(Bitmap bitmap) {

        String result = null;
        ByteArrayOutputStream baos = null;
        try {
            if (bitmap != null) {
                baos = new ByteArrayOutputStream();
                bitmap.compress(Bitmap.CompressFormat.PNG, 100, baos);

                baos.flush();
                baos.close();

                byte[] bitmapBytes = baos.toByteArray();
                result = Base64.encodeToString(bitmapBytes, Base64.DEFAULT);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                if (baos != null) {
                    baos.flush();
                    baos.close();
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return result;
    }
    public static String compressPic(String srcFilePath) throws Exception {
        String newFilePath = "";
        if(null != srcFilePath && !"".equals(srcFilePath)){
            int index = srcFilePath.lastIndexOf(".");
            newFilePath = srcFilePath.substring(0,index) + "_Compress" + srcFilePath.substring(index);
        }else{
            throw new Exception("未找到图片");
        }

        File sdFile = Environment.getExternalStorageDirectory();
        File originFile = new File(srcFilePath);
        BitmapFactory.Options options = new BitmapFactory.Options();

        //options.inJustDecodeBounds = true;

        //Bitmap emptyBitmap = BitmapFactory.decodeFile(originFile.getAbsolutePath(),options);

        options.inJustDecodeBounds = false;
        options.inSampleSize = 4;
        Bitmap resultBitmap = BitmapFactory.decodeFile(originFile.getAbsolutePath(),options);
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        resultBitmap.compress(Bitmap.CompressFormat.JPEG,100,bos);

        FileOutputStream fos = null;
        try{
            fos = new FileOutputStream(new File(newFilePath));
            fos.write(bos.toByteArray());
            fos.flush();
        }catch (Exception e){
            e.printStackTrace();
        }finally {
            if(null != fos){
                fos.close();
            }
            if(null != bos){
                bos.close();
            }
        }
        return newFilePath;

    }

    /**
     * 使用gzip进行压缩
     */
    public static String compress(String primStr) {
        if (primStr == null || primStr.length() == 0) {
            return primStr;
        }
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        GZIPOutputStream gzip = null;
        try {
            gzip = new GZIPOutputStream(out);
            gzip.write(primStr.getBytes("UTF-8"));
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (gzip != null) {
                try {
                    gzip.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return Base64.encodeToString(out.toByteArray(),Base64.DEFAULT);
    }

    /**
     * 使用gzip进行解压缩
     */
    public static String uncompress(String compressedStr) {
        if (compressedStr == null) {
            return null;
        }
        ByteArrayOutputStream out = new ByteArrayOutputStream();
        ByteArrayInputStream in = null;
        GZIPInputStream ginzip = null;
        byte[] compressed = null;
        String decompressed = null;
        try {
            compressed = Base64.decode(compressedStr,Base64.DEFAULT);
            in = new ByteArrayInputStream(compressed);
            ginzip = new GZIPInputStream(in);

            byte[] buffer = new byte[1024];
            int offset = -1;
            while ((offset = ginzip.read(buffer)) != -1) {
                out.write(buffer, 0, offset);
            }
            decompressed = out.toString("UTF-8");
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (ginzip != null) {
                try {
                    ginzip.close();
                } catch (IOException e) {
                }
            }
            if (in != null) {
                try {
                    in.close();
                } catch (IOException e) {
                }
            }
            try {
                out.close();
            } catch (IOException e) {
            }
        }
        return decompressed;
    }
}
