--populate with mock user & events 

CREATE TABLE IF NOT EXISTS feeds(
      feed_id SERIAL PRIMARY KEY,
      feed_name text,
      source_name text,
      UNIQUE (feed_name, source_name));

CREATE TABLE IF NOT EXISTS events(
      event_id SERIAL PRIMARY KEY,
      title text,
      time_processed integer,
      location text,
      start_time integer,
      end_time integer,
      repeats_weekly boolean,
      tags text[],
      url text,
      post text,
      feed_id SERIAL REFERENCES feeds);

    CREATE TABLE IF NOT EXISTS users(
      user_id SERIAL PRIMARY KEY,
      username text UNIQUE,
      password text,
      role text);

    CREATE TABLE IF NOT EXISTS user_follows_feed(
      feed_id int REFERENCES feeds ON DELETE CASCADE,
      user_id int REFERENCES users,
      PRIMARY KEY (feed_id, user_id));

INSERT INTO users(username, password) values ('foo', 'bar');
INSERT INTO feeds(feed_name) VALUES ('fakeFeed1');
INSERT INTO user_follows_feed(feed_id, user_id) VALUES (1,1);

INSERT INTO events(
	title, 
	time_processed, 
	start_time, 
	end_time,
	location, 
	repeats_weekly, 
	tags, 
	url, 
	post,
	feed_id
) values (
  'Pose with the Pope',
  1443116931 ,
  1443034800,
  1442998800,
  'Regents Grass',
  FALSE,
  '{"religion","students"}',
  'www.facebook.com/LoyolaMarymountUniversity/blah',
  'Prior to his historic arrival in Washington D.C. today, \\		
            Pope Francis made an unannounced detour to "visit" the Bluff! ‪#‎JesuitEducated‬ ‪#‎ILoveLMU‬ \\		
            STUDENTS: "Pose with the Pope" tomorrow from 12-2 p.m. on Regents Grass (end of Alumni Mall): bit.ly/posepope',
  1
);

INSERT INTO events(
  title, 
  time_processed, 
  start_time, 
  end_time,
  location, 
  repeats_weekly, 
  tags, 
  url, 
  post,
  feed_id
) values (
  'Fallapalooza',
  1439075541 ,
  1441753941,
  1441764741,
  'Sunken Gardens',
  FALSE,
  '{"music","students","concert"}',
  'www.facebook.com/LoyolaMarymountUniversity/Fallapalooza',
  'Come out to the sunken gardens today to jam out with Walk the Moon!',
  1
);

INSERT INTO events(
  title, 
  time_processed, 
  start_time, 
  end_time,
  location, 
  repeats_weekly, 
  tags,  
  url, 
  post,
  feed_id
) values (
  'Beatles for Sam',
  1439075541 ,
  1445648400,
  1445662800,
  'Sunken Gardens',
  FALSE,
  '{"music","students","concert"}',
  'https://www.facebook.com/lmula/photos/a.473141356084.282436.215120346084/10153673455746085/?type=3&theater',
  '‪#‎BTLS4SAM‬... Another campus tradition that makes you say ‪#‎ILoveLMU‬: bit.ly/lmu_btls4sam
This Friday from 6-10 p.m. outside the Foley Building, join the ninth annual Beatles for Sam concert to raise money for the Sam Wasson Scholarship Fund and honor the life of a Lion who loved the music of John, Paul, Ringo and George.',
  1
);

INSERT INTO events(
  title, 
  time_processed, 
  start_time, 
  end_time,
  location, 
  repeats_weekly, 
  tags,  
  url, 
  post,
  feed_id
) values (
  '2nd Annual Women in Athletics Day',
  1444917600 ,
  1445169600,
  1445176800,
  'Sunken Gardens',
  FALSE,
  '{"athletic","fundraising"}',
  'https://www.facebook.com/lmula/photos/a.473141356084.282436.215120346084/10153673455746085/?type=3&theater',
  '‪On Sunday, Oct. 18 the LMU Lions Athletic Fund hosts the 2nd Annual Women in \\
             Athletics Day at the Races.\n This fundraising event recognizes and celebrates \\
             our female student-athletes and their programs. Registration is now open at bit.ly/lmu_datr',
  1
);

INSERT INTO events(
  title, 
  time_processed, 
  start_time, 
  end_time,
  location, 
  repeats_weekly, 
  tags,  
  url, 
  post,
  feed_id
) values (
  'Life Sciences Building Dedication',
  1443636000 ,
  1444062600,
  1444068000,
  'Seaver',
  FALSE,
  '{"campus","science", "building"}',
  'https://www.facebook.com/lmula/photos/a.473141356084.282436.215120346084/10153673455746085/?type=3&theater',
  '‪HAPPENING NOW; Dedication of the new Seaver College Life Sciences Building!\\
             Look for our ‪#‎Periscope‬ stream of the ribbon-cutting coming up shortly; follow @loyolamarymount.',
  1
);

INSERT INTO events(
  title, 
  time_processed, 
  start_time, 
  end_time,
  location, 
  repeats_weekly, 
  tags,  
  url, 
  post,
  feed_id
) values (
  'Spring Housing App Opens',
  1444091026 ,
  1446206400,
  1446213600,
  '',
  FALSE,
  '{"housing","lion"}',
  'https://www.facebook.com/lmula/photos/a.473141356084.282436.215120346084/10153673455746085/?type=3&theater',
  '‪Live in Lion Nation this Spring: Application Opens October 30, 2015! http://studentaffairs.lmu.edu/…/prospectiv…/applyforhousing/',
  1
);

INSERT INTO events(
  title, 
  time_processed, 
  start_time, 
  end_time,
  location, 
  repeats_weekly, 
  tags,  
  url, 
  post,
  feed_id
) values (
  'Zac Brown Band',
  1444091026 ,
  1444420800,
  1444431600,
  'Hollywood Bowl',
  FALSE,
  '{"music","students","concert"}',
  'https://www.facebook.com/lmula/photos/a.473141356084.282436.215120346084/10153673455746085/?type=3&theater',
  '‪Zac Brown Band, the three-time GRAMMY winning and multi-platinum country band is coming to the Hollywood Bowl! Joing the Program assistants on a night of their Jekyll + Hyde Tour. Buses leave at 4:45pm from Hannon Field. TERMS OF AGREEMENT: required to travel in the transport provided, no refunds, no substances/alcohol free, LMU students only, MUST SIGN WAIVER IN LEAVEY 5 SUITE 300 BY 10/9',
  1
);

INSERT INTO events(
  title, 
  time_processed, 
  start_time, 
  end_time,
  location, 
  repeats_weekly, 
  tags,  
  url, 
  post,
  feed_id
) values (
  'LA Cybersecurity Summit',
  1444091026 ,
  1444474800,
  1444482000,
  '',
  FALSE,
  '{"cybersecurity","summit","free"}',
  'https://www.facebook.com/lmula/photos/a.473141356084.282436.215120346084/10153673455746085/?type=3&theater',
  '‪The LA #Cybersecurity Summit is this Saturday & features @RepTedLieu! Register for free at http://bit.ly/1VBXJ85',
  1
);

INSERT INTO events(
  title, 
  time_processed, 
  start_time, 
  end_time,
  location, 
  repeats_weekly, 
  tags,  
  url, 
  post,
  feed_id
) values (
  'LMUSnyder',
  1444091026 ,
  1444138200,
  1444145400,
  'Gersten Pavilion',
  FALSE,
  '{"history"}',
  'https://www.facebook.com/lmula/photos/a.473141356084.282436.215120346084/10153673455746085/?type=3&theater',
  '‪Will you be at Gersten Pavilion on Tuesday at 1:30pm to witness LMU history? #LMUSnyder',
  1
);

INSERT INTO events(
  title, 
  time_processed, 
  start_time, 
  end_time,
  location, 
  repeats_weekly, 
  tags,  
  url, 
  post,
  feed_id
) values (
  '60 Second Lectures',
  1444091026 ,
  1445455800,
  1445461200,
  '',
  FALSE,
  '{"lecture","learning"}',
  'https://www.facebook.com/lmula/photos/a.473141356084.282436.215120346084/10153673455746085/?type=3&theater',
  '‪Come listen to professors give lectures in under 60 sec on Oct. 21st at 7:30pm. You might be surprised by what you could learn!',
  1
);

INSERT INTO events(
  title, 
  time_processed, 
  start_time, 
  end_time,
  location, 
  repeats_weekly, 
  tags,  
  url, 
  post,
  feed_id
) values (
  'Bioethics Coffee Hour',
  1444091026 ,
  1444154400,
  1444158000,
  'Bioethics Village',
  FALSE,
  '{"bioethics","students"}',
  'https://www.facebook.com/lmula/photos/a.473141356084.282436.215120346084/10153673455746085/?type=3&theater',
  '‪Coffee Hour is an opportunity for bioethics students, staff, and faculty to come together in an informal setting and get to know one another. It will be held every Tuesday that class is in session from 6:00-7:00 pm in the Bioethics Village. Stop by any Tuesday this fall for some caffeine and casual conversation.',
  1
);

INSERT INTO events(
  title, 
  time_processed, 
  start_time, 
  end_time,
  location, 
  repeats_weekly, 
  tags,  
  url, 
  post,
  feed_id
) values (
  'Better, Faster, Stronger Job Search',
  1444091026 ,
  1445340600,
  1445342400,
  'Sunken Gardens',
  FALSE,
  '{"job","networking","social media"}',
  'https://www.facebook.com/lmula/photos/a.473141356084.282436.215120346084/10153673455746085/?type=3&theater',
  '‪Tuesday October 20 from 11:30 am - 12:00 pm. How do you develop your own personal strategic job search?  Learn the difference between various types of jobs and proven approaches to landing your first post-graduate opportunity.  Enhance your professional network by utilizing the power of social media.',
  1
);

INSERT INTO events(
  title, 
  time_processed, 
  start_time, 
  end_time,
  location, 
  repeats_weekly, 
  tags,  
  url, 
  post,
  feed_id
) values (
  'PSAT Day',
  1444091026 ,
  1444824000,
  1444834800,
  '',
  FALSE,
  '{"job","networking","social media"}',
  'https://www.facebook.com/lmula/photos/a.473141356084.282436.215120346084/10153673455746085/?type=3&theater',
  '‪Come take the PSAT on 10-14 at LMU #wrecked #testsallday',
  1
);

INSERT INTO events(
  title, 
  time_processed, 
  start_time, 
  end_time,
  location, 
  repeats_weekly, 
  tags,  
  url, 
  post,
  feed_id
) values (
  'Destruction of Historical Artifacts Discussion',
  1444091026 ,
  1444842000,
  1444849200,
  '',
  FALSE,
  '{"job","networking","social media"}',
  'https://www.facebook.com/lmula/photos/a.473141356084.282436.215120346084/10153673455746085/?type=3&theater',
  '‪The Destruction of Historical Artifacts and Monuments: A History Student-Faculty Conversation on Oct 14 from 5-7pm. #LMUHistory #History #HistoryMatters',
  1
);

INSERT INTO events(
  title, 
  time_processed, 
  start_time, 
  end_time,
  location, 
  repeats_weekly, 
  tags,  
  url, 
  post,
  feed_id
) values (
  'FOS Sports Night: Men''s Water Polo vs San Jose State',
  1444091026 ,
  1444842000,
  1444849200,
  '',
  FALSE,
  '{"job","networking","social media"}',
  'https://www.facebook.com/lmula/photos/a.473141356084.282436.215120346084/10153673455746085/?type=3&theater',
  '‪LMU offers FREE admission to all Family of Schools students, faculty, and staff. Register by clicking on the link below! ',
  1
);