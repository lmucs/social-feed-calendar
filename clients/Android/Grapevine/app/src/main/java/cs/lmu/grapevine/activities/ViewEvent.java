package cs.lmu.grapevine.activities;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.TextView;
import cs.lmu.grapevine.entities.Event;
import cs.lmu.grapevine.R;

public class ViewEvent extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_event);

        Intent intent = getIntent();
        Event eventToView = (Event)intent.getSerializableExtra("event");
        displayEvent(eventToView);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_view_event, menu);
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
        }

        return super.onOptionsItemSelected(item);
    }

    public void displayEvent(Event eventToDisplay) {
        TextView eventTitleView    = (TextView) findViewById(R.id.single_event_title);
        TextView eventDateView     = (TextView) findViewById(R.id.single_event_date);
        TextView eventLocationView = (TextView) findViewById(R.id.single_event_location);
        TextView eventUrlView      = (TextView) findViewById(R.id.single_event_url);
                
        if(!eventToDisplay.getTitle().equals(null)) {
            eventTitleView.setText(eventToDisplay.getTitle());
        }
        //any event that doesn't have a date shouldn't make it into the database
        eventDateView.setText(eventToDisplay.getDate().toString());

        if (!eventToDisplay.getLocation().equals(null)) {
            eventLocationView.setText(eventToDisplay.getLocation());
        }
        if(!eventToDisplay.getURL().equals(null)) {
            eventUrlView.setText(eventToDisplay.getURL());
        }

    }
}
