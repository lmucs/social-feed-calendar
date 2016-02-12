package cs.lmu.grapevine.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import java.util.ArrayList;
import cs.lmu.grapevine.R;
import cs.lmu.grapevine.entities.Event;

/**
 * Created by jeff on 12/10/15.
 */
public class CalendarAdapter extends EventFeedArrayAdapter {
    private ImageView calendarPage;
    private Context context;

    public CalendarAdapter(Context context, ArrayList<Event> events) {
        super(context,events);
        this.context = context;
    }

    @Override
    public View getView(int position, View eventFeedView, ViewGroup parent) {
        getTimeNow();
        Event event = filteredItems.get(position);

        if (eventFeedView == null) {
            eventFeedView = LayoutInflater.from(getContext()).inflate(R.layout.event_list_view, parent, false);
        }

        getUIElements(eventFeedView);
        setEventFields(event);
        setGrapeLogo(eventFeedView,parent);

        return eventFeedView;
    }

    private void setGrapeLogo(View eventView, ViewGroup parent) {
        LinearLayout calendarPageContainer = (LinearLayout) eventView.findViewById(R.id.image_container);
        calendarPageContainer.removeAllViews();

        LinearLayout grapeImage = (LinearLayout)LayoutInflater.from(getContext()).inflate(R.layout.grape_logo, parent, false);
        calendarPageContainer.addView(grapeImage);

    }
}
