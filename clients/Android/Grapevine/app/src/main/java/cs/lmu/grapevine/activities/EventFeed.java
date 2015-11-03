package cs.lmu.grapevine.activities;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.ListView;
import cs.lmu.grapevine.R;
import cs.lmu.grapevine.listeners.EventListClickListener;
import cs.lmu.grapevine.requests.EventFeedRequest;

public class EventFeed extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.event_feed);
        ListView eventFeed = (ListView)findViewById(R.id.event_feed);
        eventFeed.setOnItemClickListener(new EventListClickListener(this));

        EventFeedRequest getUserEvents = new EventFeedRequest(this);
        Login.httpRequestQueue.add(getUserEvents);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_event_feed, menu);
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
            viewCalendar();
        } else if (id == R.id.action_add_group) {
            launchAddGroup();
        }

        return super.onOptionsItemSelected(item);
    }

    public void viewCalendar() {
        Intent launchCalendarView = new Intent(getApplicationContext(), CalendarView.class);
        startActivity(launchCalendarView);
    }

    public void launchAddGroup() {
        Intent addGroup = new Intent(this, AddGroup.class);
        startActivity(addGroup);
    }
}