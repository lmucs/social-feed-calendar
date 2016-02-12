package cs.lmu.grapevine.requests.listeners.success;

import android.app.Activity;
import android.widget.Toast;
import com.android.volley.Response;
import org.json.JSONArray;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import cs.lmu.grapevine.R;
import cs.lmu.grapevine.activities.EventFeed;
import cs.lmu.grapevine.activities.Login;
import cs.lmu.grapevine.entities.Event;

/**
 * Created by jeff on 12/1/15.
 */
public class RefreshEventFeedSuccessListener implements Response.Listener {
    private Activity parentActivity;

    public RefreshEventFeedSuccessListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }
    
    @Override
    public void onResponse(Object response) {
        addNewEventsToFeedFrom((JSONArray)response);
        toastSuccessMessage();
    }

    private void toastSuccessMessage() {
        int duration = Toast.LENGTH_SHORT;
        Toast toast = Toast.makeText(parentActivity, parentActivity.getString(R.string.refresh_success_toast), duration);
        toast.show();
    }

    private void addNewEventsToFeedFrom(JSONArray response) {
       List<Event> newEvents = EventSuccessListener.deserializeJson(response);;

        for (Event event : newEvents) {
            EventFeed.usersEventsAdapter.add(event);
        }

        for (int i = 0; i < EventFeed.usersEventsAdapter.getCount(); i++) {
            if (((Event)EventFeed.usersEventsAdapter.getItem(i)).isFinished()) {
                EventFeed.usersEventsAdapter.remove(EventFeed.usersEventsAdapter.getItem(i));
            }
        }

       Login.lastRefresh = new Date().getTime();

    }
}
