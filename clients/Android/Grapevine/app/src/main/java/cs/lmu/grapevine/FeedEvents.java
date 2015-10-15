package cs.lmu.grapevine;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;

public class FeedEvents extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_feed_events);
        Intent loginIntent = getIntent();
        String jwt = loginIntent.getStringExtra("JWT");

        //print out the jwt received from the login response
        TextView eventFeed = (TextView)(findViewById(R.id.event_feed));
        eventFeed.setText(jwt);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_feed_events, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        } else if (id == R.id.action_launch_calendar) {
            Intent launchCalendarView = new Intent(getApplicationContext(), CalendarView.class);
            startActivity(launchCalendarView);
        }

        return super.onOptionsItemSelected(item);
    }
}