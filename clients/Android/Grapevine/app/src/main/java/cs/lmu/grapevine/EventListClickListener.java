package cs.lmu.grapevine;

import android.app.Activity;
import android.content.Intent;
import android.view.View;
import android.widget.AdapterView;

import cs.lmu.grapevine.Entities.Event;

/**
 * Created by jeff on 10/9/15.
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
