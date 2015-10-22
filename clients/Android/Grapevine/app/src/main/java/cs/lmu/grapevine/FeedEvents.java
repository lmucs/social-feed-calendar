package cs.lmu.grapevine;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ListView;

import com.google.gson.Gson;

import java.util.List;

import cs.lmu.grapevine.Entities.Event;
import cs.lmu.grapevine.requests.EventFeedRequest;

public class FeedEvents extends AppCompatActivity {
    Gson gson = new Gson();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_feed_events);
        ListView eventFeed = (ListView)findViewById(R.id.event_feed);
        eventFeed.setOnItemClickListener(new EventListClickListener(this));

        EventFeedRequest getUserEvents = new EventFeedRequest(this);
        MainActivity.httpRequestQueue.add(getUserEvents);
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