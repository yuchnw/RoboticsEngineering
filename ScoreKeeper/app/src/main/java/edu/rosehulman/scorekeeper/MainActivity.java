package edu.rosehulman.scorekeeper;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

public class MainActivity extends AppCompatActivity {

    private TextView colorScore;
    private TextView nearBallScore;
    private TextView farBallScore;
    private TextView robotHomeScore;
    private TextView wbScore;
    private TextView totalScore;
    private int color;
    private int wb;
    private int near;
    private int far;
    private int home;
    private int total;
    private int previousColor;
    private int previouswb;
    private int previousnear;
    private int previousfar;
    private int previoushome;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        colorScore = (TextView) findViewById(R.id.textview_color);
        nearBallScore = (TextView) findViewById(R.id.textview_nearBall);
        farBallScore = (TextView) findViewById(R.id.textview_farBall);
        robotHomeScore = (TextView) findViewById(R.id.textview_robotHome);
        wbScore = (TextView) findViewById(R.id.textview_wb);
        totalScore = (TextView) findViewById(R.id.total);

        total = 0;
        wb = 0;
        near = 0;
        far = 0;
        home = 0;
        total = 0;
        previousColor = 0;
        previousnear = 0;
        previousfar = 0;
        previoushome = 0;
        previouswb = 0;
    }

    public void pressFix3(View view){
        color = 0;
        total += (color-previousColor);
        colorScore.setText(getString(R.string.message_colorScore, color));
        totalScore.setText(getString(R.string.message_totalScore, total));
        previousColor = color;
    }

    public void pressFix2(View view){
        color = 25;
        total += (color-previousColor);
        colorScore.setText(getString(R.string.message_colorScore, color));
        totalScore.setText(getString(R.string.message_totalScore, total));
        previousColor = color;
    }

    public void pressFix1(View view){
        color = 75;
        total += (color-previousColor);
        colorScore.setText(getString(R.string.message_colorScore, color));
        totalScore.setText(getString(R.string.message_totalScore, total));
        previousColor = color;
    }

    public void pressFix0(View view){
        color = 150;
        total += (color-previousColor);
        colorScore.setText(getString(R.string.message_colorScore, color));
        totalScore.setText(getString(R.string.message_totalScore, total));
        previousColor = color;
    }

    public void pressUpdate(View view){
        int distance1 = Integer.parseInt(((EditText) findViewById(R.id.editNear)).getText().toString());
        int distance2 = Integer.parseInt(((EditText) findViewById(R.id.editFar)).getText().toString());
        int distance3 = Integer.parseInt(((EditText) findViewById(R.id.editHome)).getText().toString());

        if(distance1>45){
            near = 0;
        }else if(distance1<=45 & distance1>30){
            near = 10;
        }else if(distance1<=30 & distance1>20){
            near = 50;
        }else if(distance1<=20 & distance1>10){
            near = 80;
        }else if(distance1<=10 & distance1>5){
            near = 100;
        }else if(distance1<=5){
            near = 110;
        }

        if(distance2>45){
            far = 0;
        }else if(distance2<=45 & distance2>30){
            far = 20;
        }else if(distance2<=30 & distance2>20){
            far = 100;
        }else if(distance2<=20 & distance2>10){
            far = 160;
        }else if(distance2<=10 & distance2>5){
            far = 200;
        }else if(distance2<=5){
            far = 220;
        }

        if(distance3>45){
            home = 0;
        }else if(distance3<=45 & distance3>30){
            home = 10;
        }else if(distance3<=30 & distance3>20){
            home = 50;
        }else if(distance3<=20 & distance3>10){
            home = 80;
        }else if(distance3<=10 & distance3>5){
            home = 100;
        }else if(distance3<=5){
            home = 110;
        }

        total = total + near + far + home - previousnear - previousfar - previoushome;
        previousnear = near;
        previousfar = far;
        previoushome = home;
        nearBallScore.setText(getString(R.string.message_nearBall, near));
        farBallScore.setText(getString(R.string.message_farBall, far));
        robotHomeScore.setText(getString(R.string.message_robotHome, home));
        totalScore.setText(getString(R.string.message_totalScore, total));
    }

    public void pressFail(View view){
        wb = 0;
        total += (wb - previouswb);
        wbScore.setText(getString(R.string.message_wbScore, wb));
        totalScore.setText(getString(R.string.message_totalScore, total));
        previouswb = wb;
    }

    public void pressSuccess(View view){
        wb = 60;
        total += (wb - previouswb);
        wbScore.setText(getString(R.string.message_wbScore, wb));
        totalScore.setText(getString(R.string.message_totalScore, total));
        previouswb = wb;
    }

    public void pressReset(View view){
        color = 0;
        wb = 0;
        near = 0;
        far = 0;
        home = 0;
        total = 0;
        previousColor = 0;
        previousnear = 0;
        previousfar = 0;
        previoushome = 0;
        previouswb = 0;
        colorScore.setText(getString(R.string.message_colorScore, color));
        nearBallScore.setText(getString(R.string.message_nearBall, near));
        farBallScore.setText(getString(R.string.message_farBall, far));
        robotHomeScore.setText(getString(R.string.message_robotHome, home));
        wbScore.setText(getString(R.string.message_wbScore, wb));
        totalScore.setText(getString(R.string.message_totalScore, total));
    }
}
