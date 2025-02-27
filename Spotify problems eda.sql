--1. EDA on spotify dataset

Delete from spotify
where duration_min=0;

Select * from spotify
where duration_min=0;

select *
from spotify;

--Basic EDA Questions
--1. Tracks with more than 1 billion streams

Select distinct(track)
from spotify
where stream> 100000000;

 --2. Albums and artists

 Select distinct album, artist 
 from spotify;

 --3. Total comments for tracks which are licensed
 Select sum(comments) as total_comments
 from spotify 
 where licensed='True';

 --4. Single album tracks

 Select distinct(track) as single_album_tracks
 from spotify
 where album_type='single';

 --5. Total tracks by each artist

 Select artist, count(*)as total_number_of_sobgs
 from spotify
 group by artist
 order by 2;
 

--Intermediate

--6. Average danceability of tracks in each album

Select album, avg(danceability)as average_danceability
from spotify
group by album
order by 2 desc;

--7. Top 5 tracks with highest energy values
Select track,max(energy)
from spotify
group by 1
order by max(energy) desc
limit 5;

--8. All tracks with view and likes for official video

Select track, sum(views) as total_views, sum(likes) as total_likes
from spotify
where official_video='True'
group by 1
order by 2 desc
limit 5;


 --9. For each album calculate the total views for associated tracks

 select album, track, sum(views)as total_views
 from spotify
 group by album,track
 order by 3 desc;


--10. All tracks where streaming on spotify is more than on youtube.

with streaming as
(Select track,
coalesce(sum(case 
when most_played_on='Spotify'
then stream end),0) as streamed_on_spotify,
coalesce(sum(case when most_played_on='Youtube'
then stream end),0) as streamed_on_youtube
from spotify
group by 1)

select track
from streaming 
where streamed_on_spotify >
streamed_on_youtube;


--Advanced queries

1.--Top 3 most viewed tracks for each artist using window finctions

with ranking as
(Select track,artist,sum(views)as total_views, dense_rank() over(partition by artist order by sum(views) desc)as rank
from spotify
group by track, artist)

select * from ranking
where rank<=3;

--11. Tracks with livliness above average

Select track, liveness
from spotify
where liveness >
(Select avg(liveness)
from spotify);


--12. Albums as per energy levels

with energy as (

Select album, max(energy)as highest,min(energy)as lowest, max(energy)-min(energy)as difference
from spotify
group by album
)
select album, difference
from energy
order by difference desc;


