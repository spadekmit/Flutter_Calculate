package com.spadek.xiaoming;

import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    //如果api >= 23 需要显式申请权限
    if (Build.VERSION.SDK_INT >= 23) {
      if (ContextCompat.checkSelfPermission(this,Manifest.permission.READ_PHONE_STATE) != PackageManager.PERMISSION_GRANTED) {
          ActivityCompat.requestPermissions(this,new String[]{Manifest.permission.READ_PHONE_STATE} , 0);
      }
    }

    GeneratedPluginRegistrant.registerWith(this);
  }
}
