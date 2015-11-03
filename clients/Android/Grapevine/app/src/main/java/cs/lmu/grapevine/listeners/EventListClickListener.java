package cs.lmu.grapevine.listeners;

import android.app.Activity;
import android.content.Intent;
import android.view.View;
import android.widget.AdapterView;
import cs.lmu.grapevine.activities.ViewEvent;
import cs.lmu.grapevine.entities.Event;

/**
 * On click listener to launch event view from event feed.
 */
public class EventListClickListener implements AdapterView.OnItemClickListener {
    private Activity parentActivity;

    public EventListClickListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    @Override
    public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
        Event selectedEvent = (Event) parent.getItemAtPosition(position);

        Intent viewEvent = new Intent(parentActivity, ViewEvent.class);
        viewEvent.putExtra("event", selectedEvent);
        parentActivity.startActivity(viewEvent);
    }
}
