package cs.lmu.grapevine.listeners;

import android.app.Activity;
import android.view.View;
import android.widget.Button;
import android.widget.Filter;
import android.widget.ListView;
import android.widget.TextView;
import com.roomorama.caldroid.CaldroidListener;
import java.text.SimpleDateFormat;
import java.util.Date;
import cs.lmu.grapevine.R;
import cs.lmu.grapevine.activities.CalendarView;
import cs.lmu.grapevine.adapters.EventFeedArrayAdapter;

/**
 * Created by jeff on 11/3/15.
 */
public class CalendarListener extends CaldroidListener {
    private Activity parentActivity;

    public CalendarListener(Activity parentActivity) {
        this.parentActivity = parentActivity;
    }

    @Override
    public void onSelectDate(Date date, View view) {
        updateFeedDisplayDate(date);
        filterEventsOn(date);
    }

    public void updateFeedDisplayDate(Date date) {
        SimpleDateFormat formatter = new SimpleDateFormat("EEEE MMMM dd, yyyy");
        String formattedDate = formatter.format(date);

        TextView dateContainer = (TextView)parentActivity.findViewById(R.id.calendar_feed_date_container);
        dateContainer.setText(formattedDate);
    }

    public void filterEventsOn(Date date) {
       ListView eventFeed = (ListView)parentActivity.findViewById(R.id.calendar_feed);
        EventFeedArrayAdapter eventFeedAdapter = (EventFeedArrayAdapter)eventFeed.getAdapter();
        SimpleDateFormat dateStringFormat = new SimpleDateFormat("M/d/yyyy");
        String eventDay = dateStringFormat.format(date);

        if (eventFeedAdapter != null) {
            Filter eventFilter = eventFeedAdapter.getFilter();
            eventFilter.filter(eventDay);
        }

    }

    @Override
    public void onCaldroidViewCreated() {
        Button leftButton  = CalendarView.calendar.getLeftArrowButton();
        Button rightButton = CalendarView.calendar.getRightArrowButton();
        TextView textView  = CalendarView.calendar.getMonthTitleTextView();

        // Do customization here
        leftButton.setBackgroundResource(R.drawable.calendar_left_button);
        rightButton.setBackgroundResource(R.drawable.calendar_right_button);
    }

}
