package edu.rosehulman.myfieldsensors;

import android.app.Activity;
import android.location.Location;
import android.support.annotation.NonNull;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ToggleButton;

import edu.rosehulman.me435.FieldGps;
import edu.rosehulman.me435.FieldGpsListener;
import edu.rosehulman.me435.FieldOrientation;
import edu.rosehulman.me435.FieldOrientationListener;

public class MainActivity extends Activity implements FieldGpsListener, FieldOrientationListener{

    private int mGpsCounter = 0;
    private TextView mGpsXTextView, mGpsYTextView, mGpsHeadingTextView, mGpsCounterTextView, mGpsAccuracyTextView;
    private TextView mSensorHeadingTextView;
    private FieldGps mFieldGps;
    private FieldOrientation mFieldOrientation;
    private boolean mSetFieldOrientationWithGpsHeadings = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);

        mGpsXTextView = findViewById(R.id.gps_x_textview);
        mGpsYTextView = findViewById(R.id.gps_y_textview);
        mGpsHeadingTextView = findViewById(R.id.gps_heading_textview);
        mGpsCounterTextView = findViewById(R.id.gps_counter_textview);
        mGpsAccuracyTextView = findViewById(R.id.gps_accuracy_textview);
        mSensorHeadingTextView = findViewById(R.id.sensor_heading_textview);

        mFieldGps = new FieldGps(this);
        mFieldOrientation = new FieldOrientation(this);
    }

    @Override
    protected void onStart(){
        super.onStart();
        mFieldGps.requestLocationUpdates(this);
        mFieldOrientation.registerListener(this);
    }

    @Override
    protected void onStop(){
        super.onStop();
        mFieldGps.removeUpdates();
        mFieldOrientation.unregisterListener();
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions,@NonNull int[] grantResults){
        super.onRequestPermissionsResult(requestCode,permissions,grantResults);
        mFieldGps.requestLocationUpdates(this);
    }

    public void handleSetOrigin(View view){
        Log.d("FS","You clicked SET ORIGIN");
        Toast.makeText(this,"SET ORIGIN",Toast.LENGTH_SHORT).show();
        mFieldGps.setCurrentLocationAsOrigin();
    }

    public void handleSetXAxis(View view){
        Log.d("FS","You clicked SET X AXIS");
        Toast.makeText(this,"SET X AXIS",Toast.LENGTH_SHORT).show();
        mFieldGps.setCurrentLocationAsLocationOnXAxis();
    }

    public void handleSetHeadingTo0(View view){
        mFieldOrientation.setCurrentFieldHeading(0);
    }

    public void handleToggle(View view){
        ToggleButton tb = (ToggleButton)view;
        mSetFieldOrientationWithGpsHeadings = tb.isChecked();
    }

    @Override
    public void onLocationChanged(double x, double y, double heading, Location location){
        //Update X and Y labels
        mGpsXTextView.setText((int)x + "ft");
        mGpsYTextView.setText((int)y + "ft");

        //If there is a heading we'll update the GPS HEADING label as well
        if(heading <= 180.0 && heading > -180.0){
            mGpsHeadingTextView.setText((int)heading + "°");
            if(mSetFieldOrientationWithGpsHeadings){
                mFieldOrientation.setCurrentFieldHeading(heading);
            }
        } else {
            mGpsHeadingTextView.setText("---");
        }

        if(location.hasAccuracy()){
            mGpsAccuracyTextView.setText((int)location.getAccuracy()*mFieldGps.FEET_PER_METER + "ft");
        }

        //Update the GPS counter
        mGpsCounter++;
        mGpsCounterTextView.setText(Integer.toString(mGpsCounter));
    }

    @Override
    public void onSensorChanged(double fieldHeading, float[] orientationValues){
        mSensorHeadingTextView.setText((int)fieldHeading+"°");
    }
}
