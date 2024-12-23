-- SEED USERS --- START
CREATE OR REPLACE FUNCTION create_user(email text) RETURNS UUID
AS $$
DECLARE
user_id uuid;
BEGIN
user_id := gen_random_uuid();

INSERT INTO auth.users (
  instance_id,
  id,
  aud,
  role,
  email,
  encrypted_password,
  email_confirmed_at,
  recovery_sent_at,
  last_sign_in_at,
  raw_app_meta_data,
  raw_user_meta_data,
  created_at,
  updated_at,
  confirmation_token,
  email_change,
  email_change_token_new,
  recovery_token
)
VALUES
  (
  '00000000-0000-0000-0000-000000000000',
  user_id,
  'authenticated',
  'authenticated',
  email,
  extensions.crypt('123456', extensions.gen_salt('bf')),
  NOW(),
  NOW(),
  NOW(),
  '{"provider":"email","providers":["email"]}',
  '{}',
  NOW(),
  NOW(),
  '',
  '',
  '',
  ''
  );

INSERT INTO
    auth.identities (
    id,
    user_id,
    identity_data,
    provider_id,
    provider,
    last_sign_in_at,
    created_at,
    updated_at
    )
VALUES
    (
    gen_random_uuid(),
    user_id,
    format('{"sub":"%s","email":"%s"}', user_id::text, email)::jsonb,
    gen_random_uuid(),
    'email',
    NOW(),
    NOW(),
    NOW()
    );

    RETURN user_id;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- pl/pgsql wrapper is required in order to execute function when seeding
DO $$
DECLARE
    unames TEXT[] := ARRAY['vikki', 'hannah', 'georgia', 'riona', 'david'];
    uname TEXT;
BEGIN    
    -- delete existing users
    DELETE FROM auth.users;

    FOREACH uname IN ARRAY unames LOOP
        PERFORM create_user(uname || '@nc.dev');
    END LOOP;
END $$;

DROP FUNCTION create_user;
-- SEED USERS --- END

-- SEED MARKERS -- START
CREATE TYPE temp_marker_type AS (
    mark_id INT,
    title TEXT,
    address TEXT,
    description TEXT,
    long FLOAT,
    lat FLOAT,
    image TEXT
);

DO $$
DECLARE
    arr temp_marker_type[];
    m temp_marker_type;
BEGIN
    arr := ARRAY [
(2,'Andesite Boulder','Oxford Rd, Manchester, M13 9PL','On a lawn in the University of Manchester’s Old Quadrangle, a great lump of lava stands proudly as an unusual decorative feature surrounded by the Quad’s grand ivy-covered Gothic architecture. Balanced on a stone plinth in front of the Beyer Building, the andesite boulder weighs over 20 tons and measures up at eight feet by nine feet by five feet. It’s understood to have made its way to the area from Borrowdale in the Lake District during the last Ice Age, around 20,000 years ago. Having journeyed over 80 miles, the well-traveled boulder remained at rest 28 feet below the surface for centuries. That is, until February 1888, when workers discovered the rock beneath the Oxford Road corridor while making excavations during the construction of new sewers. The rock has been on public display in its current position since the excavations. There in the Old Quad, which is often the scene of graduation ceremony celebrations, it stands as a fitting presence—something that traveled far and arrived in Manchester tens of thousands of years before students flocked to the place from all over the globe.',-2.2346,53.4658,'https://s0.geograph.org.uk/geophotos/04/36/30/4363004_4875486c.jpg'),
(3,'Castlesteads','Burrs Country Park, Woodhill Rd, Bury, BL8 1DA','Castlesteads is an Iron Age promontory hill fort on the east bank of the River Irwell. The site is defended by a 120 m (390 ft) long and 6 m (20 ft) wide ditch, and a silted up channel of the river. Although there is no immediate access currently to the top of the site, there are good views of its steep slopes from Burrs Country Park. The hillside is now covered in trees, but you can get a sense of just how well defended this site was by walking around the bottom of it. The fort dates from the late Iron Age. It was occupied from the 5th Century BC and continued in use into the first and second century after the Roman invasion. Such places were constructed as defensive sites, but also were status pieces, radiating power out to the surrounding countryside. In the early days following the Roman invasion, Cartimandua, queen of the local tribe, the Brigantes, was a client ruler of the Romans, so it may well be that this was the reason it was not slighted (attacked) by them.',-2.306955,53.612875,'https://farm5.staticflickr.com/4142/4953876746_d341f4d88c.jpg'),
(4,'Mamucium','Castlefield, Manchester','Mamucium, also known as Mancunium, is a former Roman fort in the Castlefield area of Manchester in North West England. The castrum, which was founded c. AD 79 within the Roman province of Roman Britain, was garrisoned by a cohort of Roman auxiliaries near two major Roman roads running through the area. Several sizeable civilian settlements (or vicus) containing soldiers'' families, merchants and industry developed outside the fort. The ruins were left undisturbed until Manchester expanded rapidly during the Industrial Revolution in the late 18th century. Most of the fort was levelled to make way for new developments such as the construction of the Rochdale Canal and the Great Northern Railway. The site is now part of the Castlefield Urban Heritage Park that includes renovated warehouses. A section of the fort''s wall along with its gatehouse, granaries, and other ancillary buildings from the vicus have been reconstructed and are open to the public.',-2.255209,53.475455,'https://www.historyhit.com/app/uploads/2021/04/CastlefieldRomanFort-2.jpg'),
(5,'Castleshaw Roman Fort','Delph, Oldham, OL3 5LZ','A fort was established at Castleshaw by the Romans, for a garrison of 500 auxiliary soldiers, as part of the frontier defences along the road between Chester and York. It was slighted in 90, but a smaller fort – or fortlet – was built on the site in 105, designed for a garrison of less than 100. A civilian settlement (vicus), made up of traders and hangers on of the soldiers, grew around the fort in the 2nd century. The fortlet was abandoned in the mid 120s when it was superseded by the neighbouring forts at Manchester and Slack. About the same time, the civilian settlement was abandoned. A series of ditches and earthworks was built to mark the site.',-2.003057,53.583289,'https://webbaviation.co.uk/aerial/_data/i/galleries/Lancashire/Oldham/CastleshawRomanFortgb00435-me.jpg'),
(6,'Nico Ditch','Ashton-under-Lyne','Nico Ditch is an earthwork stretching from Ashton Moss in the east to Hough Moss in the west. According to legend, the ditch was dug in a single night as a defence against Viking invaders in 869–870. However, the U-shaped profile of the ditch indicates it was not defensive as it would most likely be V-shaped. It was probably used as an administrative boundary. The ditch is visible in sections, and in places is about 1.5 m (4.9 ft) deep and up to 4 m (13 ft) wide.',-2.399854,53.453083,'https://archaeologytea.wordpress.com/wp-content/uploads/2020/01/nico-ditch-in-gorton-2008b.jpg?w=443&h=332'),
(7,'Baguley Hall','Hall Ln, Wythenshawe, Manchester, M23 1NP','Situated on Hall Lane in Baguley, the hall was built in the 14th century for the de Baguley family. It’s one of the oldest surviving Timber Halls left in the United Kingdom. Interestingly, the construction of the house - designed around oversized planks - was believed to have connections with Danish Viking boat-building techniques. It is thought the hall was created as a manor house before being turned into a farmhouse. It has a medieval north wing remodeled in the 17th century; a 16th-century porch; and an early 17th-century south wing. The hall was owned by the de Baguley family - but later on came into the possession of the Legh family, who had the property for about 400 years. The final male heir of the home was Edward Legh. He married Eleanor, who was the daughter of William Tatton of Wythenshawe Hall. Together they had three daughters, who couldn’t inherit so at that point the house was leased to the Viscount Allen. In 1749 the estate was bought by one Joseph Jackson of Rostherne who''s family had married into the Leghs. Baguley Hall is considered one of the finest surviving medieval halls in the northwest of England.',-2.278265,53.395189,'https://hodgepodgedays.co.uk/wp-content/uploads/2018/07/DSC_0023-500x333.jpg'),
(8,'Smithhills Hall','Smithills Dean Rd, Bolton, BL1 7NP','Smithills Hall was originally built in the early 14th century, but was extended in the 15th and 16th centuries. The oldest surviving part is the great hall, which dates from the early 15th century. The site was originally moated, however no trace of the moat survives. Smithills Hall is now a Grade I listed building and open to the public as a museum.',-2.456083,53.602201,'https://assets.simpleviewinc.com/simpleview/image/upload/c_limit,h_1200,q_75,w_1200/v1/clients/manchester/smithillsHall_9a33ec3b-78cd-4902-b03f-bd4148196871.jpg'),
(9,'Bramhall Hall','Hall Rd, Bramhall, Stockport, SK7 3NX','Bramall Hall is a superb example of a Tudor Manor House with origins dating back to the Middle Ages. One of the most beautiful treasures of England, is of great national importance. The magnificent 16th Century wall paintings, striking Elizabethan plaster ceiling, the Victorian Kitchens and Servants’ Quarters give this Hall its unique charm.',-2.1667301,53.3738854,'https://cdn0.hitched.co.uk/vendor/7205/3_2/960/jpg/x-47_4_187205-161115662823753.jpeg'),
(10,'Hanging Bridge','Cateaton St, Manchester','The current structure was built in 1421; however the first reference to the bridge was in 1343. The bridge, which is 33 m (108 ft) long and 2.7 m (8.9 ft) wide, spanned Hanging Ditch and was part of medieval Manchester''s defences. Hanging Bridge was probably obscured by housing in the 1770s as a result of Manchester''s expansion. It was uncovered in the 1880s, and again in the late 20th century, and is now on display in Manchester Cathedral''s visitor centre.',-2.244773,53.484733,'https://manchesterhistory.net/manchester/bridges/hangingditch1.jpg'),
(11,'Manchester Cathedral','Victoria St, Manchester, M3 1SX','Manchester Cathedral, formally the Cathedral and Collegiate Church of St Mary, St Denys and St George, is the mother church of the Anglican Diocese of Manchester, seat of the Bishop of Manchester and the city''s parish church. It has been around for over 1300 years and its medieval structure was built by Henry V, dating back to 1421.  It has become a go to venue for hosting a multitude of events, concerts, gigs, brand launches, conferences, community events, fine dining and grand gala dinners.',-2.244868,53.485169,'https://assets.simpleviewinc.com/simpleview/image/upload/c_limit,h_1200,q_75,w_1200/v1/clients/manchester/3_IMG_6851_3__bc045f34-e4a1-4f75-aadc-229cf41cdfa7.jpg'),
(12,'Underbank Hall','Stockport, SK1 1LA','Underbank Hall is a 16th-century town house dating back to the 15th century. It was the home of a branch of the Arden family of Bredbury, who were related to William Shakespeare on his mother''s side.',-2.1597549,53.411227,'https://images.ctfassets.net/ii3xdrqc6nfw/20Jp8UB3yc8XO3m4C73MVL/3d6b176dea6475d1c20ccd8ead9dc55d/modern-3.jpg'),
(13,'Clayton Hall','Clayton Park, Ashton New Rd, Clayton, Manchester, M11 4RU','Clayton Hall is a 15th-century manor house on Ashton New Road in Clayton, Manchester, England, hidden behind trees in a small park. The hall is a Grade II* listed building, the mound on which it is built is a scheduled ancient monument, and a rare example of a medieval moated site.',-2.17999,53.48375,'https://upload.wikimedia.org/wikipedia/commons/a/ab/Clayton_Hall_in_2005.jpg'),
(14,'Staircase House','30/31 Market Pl, Stockport, SK1 1ES','Staircase House is a beautifully restored 15th century townhouse situated in Stockport''s historic Market Place. Also known as Stockport Museum, is a Grade II* listed medieval building dating from around 1460. The house is famous for its rare Jacobean cage newel staircase.',-2.156429,53.411589,'https://upload.wikimedia.org/wikipedia/commons/thumb/b/ba/Staircasehouse.JPG/640px-Staircasehouse.JPG'),
(15,'Bury Castle Remains','Bury, BL9 0LQ','Bury Castle is a manor house built in 1469, replacing an earlier building on the same site from the late 14th century. It was built by Sir Thomas Pilkington, Lord of the Manors of Bury and Pilkington, and fortified with permission of the king; it was razed to the ground when Sir Thomas had his lands confiscated for supporting the losing side in the War of the Roses. Some of the castle remains have been excavated and are on display to the public.',-2.298442,53.593879,'https://lancashirepast.com/wp-content/uploads/2015/03/dscf0298.jpg?w=1024'),
(16,'Ordsall Hall','322 Ordsall Ln, Salford, M5 3AN','Ordsall Hall is a large former manor house in the historic parish of Ordsall, Lancashire, now part of the City of Salford, in Greater Manchester, England. It dates back more than 750 years, although the oldest surviving parts of the present hall were built in the 15th century. The most important period of Ordsall Hall''s life was as the family seat of the Radclyffe family, who lived in the house for more than 300 years. The hall was the setting for William Harrison Ainsworth''s 1842 novel Guy Fawkes, written around the plausible although unsubstantiated local story that the Gunpowder Plot of 1605 was planned in the house.',-2.277833,53.469613,'https://assets.simpleviewinc.com/simpleview/image/fetch/c_limit,h_1200,q_75,w_1200/http://manchester.newmindmedia.com/wsimgs/ordsall-hall_1__1716811514.jpg'),
(17,'Turton Tower','Chapeltown Rd, Chapeltown, Bolton, BL7 0HG','Turton Tower is a manor house in Chapeltown in North Turton, Borough of Blackburn with Darwen, Lancashire, England. It is a scheduled ancient monument and a Grade I listed building It was built in the late Middle Ages as a two-storey stone pele tower which was altered and enlarged mainly in late 16th century. It is built on high ground 600 feet above sea level about four miles north of Bolton. William Camden described it as being built amongst precipices and wastes. A north wing and additions were made during the reign of Queen Elizabeth I and alterations were made during the early years of Queen Victoria.',-2.408975,53.632511,'https://www.lancashiretelegraph.co.uk/resources/images/10279562/?type=responsive-gallery-fullscreen'),
(18,'Little Moreton Hall','Newcastle Rd, Congleton, Cheshire, CW12 4SD','The National Trust''s Little Moreton Hall, Cheshire, is an iconic Tudor manor house, moat and manicured knot garden. Also known as Old Moreton Hall, it is a half-timbered manor house 4.5 miles (7.2 km) south-west of Congleton in Cheshire, England. The earliest parts of the house were built for the prosperous Cheshire landowner William Moreton in about 1504–08 and the remainder was constructed in stages by successive generations of the family until about 1610. The building is highly irregular, with three asymmetrical ranges forming a small, rectangular cobbled courtyard. A National Trust guidebook describes Little Moreton Hall as being lifted straight from a fairy story, a gingerbread house.” The house''s top-heavy appearance, like a stranded Noah''s Ark, is due to the Long Gallery that runs the length of the south range''s upper floor.',-2.2543852,53.1271053,'https://upload.wikimedia.org/wikipedia/commons/2/27/LittleMoretonHall.jpg'),
(19,'Lyme Park','Disley, Stockport, SK12 2NR','Lyme Park is a large estate south of Disley, Cheshire, England, managed by the National Trust and consisting of a mansion house surrounded by formal gardens and a deer park in the Peak District National Park. The house is the largest in Cheshire.',-2.054881,53.338461,'https://upload.wikimedia.org/wikipedia/commons/c/c7/South_facade_of_Lyme_Park_house%2C_2013.jpg'),
(20,'Shambles Square','Shambles Square, 1-3 Cathedral Gates, Manchester, M3 1SW','Shambles Square is a historic square situated right next to Manchester Cathedral, and is home to four main pubs: Crown & Anchor, The Old Wellington, Sinclairs Oyster Bar, and The Mitre Hotel. The term shambles comes from the name of the street where butchers would slaughter and sell meat. The Old Wellington is one of the only surviving Tudor buildings in Manchester city centre. ',-2.244024,53.48452,'https://d2joqs9jfh6k92.cloudfront.net/wp-content/uploads/2019/05/15144002/unnamed-file.jpg'),
(21,'Dunham Massey Hall & Gardens','Altrincham, WA14 4SJ','Dunham Massey Hall, usually known simply as Dunham Massey, is an English country house in the parish of Dunham Massey in the district of Trafford, near Altrincham, Greater Manchester. During World War I it was temporarily used as the Stamford Military Hospital. It was designated a Grade I listed building on 5 March 1959. It has been owned by the National Trust since the death of Roger Grey, 10th and last Earl of Stamford in 1976.',-2.399899,53.382216,'https://upload.wikimedia.org/wikipedia/commons/thumb/9/97/Dunham_Massey_2015_105.jpg/1200px-Dunham_Massey_2015_105.jpg'),
(22,'Ringley Old Bridge','Stoneclough, Radcliffe, Manchester, M26 1GT','Ringley Old Bridge is a stone bridge over the River Irwell, built in 1677 to replace a wooden one washed away in 1673. It comprises of two large semi-circular arches with a smaller arch, possibly a tow arch, at the western end. It is still used today, having been pedestrianised, and is a Grade II* listed building.',-2.358625,53.543958,'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4d/Ringley_old_bridge.jpg/800px-Ringley_old_bridge.jpg'),
(23,'St Ann’s Church','St Ann St, Manchester, M2 7LF','At the beginning of the 18th century, Manchester was a small rural town, little more than a village, with many fields and timber-framed houses. A large cornfield named Acres Field, which is now St Ann''s Square, became the site for St Ann''s Church.',-2.246066,53.481748,'https://stannsmanchester.com/wp-content/uploads/2012/03/IMG_6034.jpg'),
(24,'Tatton Park','Tatton Park Gardens, Knutsford, WA16 6QN','Tatton Park is a historic estate in Cheshire, England, north of the town of Knutsford. It contains a mansion, Tatton Hall; a medieval manor house, Tatton Old Hall; Tatton Park Gardens, a farm and a deer park of 2,000 acres (8.1 km2). It is a popular visitor attraction and hosts over a hundred events annually. The estate is owned by the National Trust and is managed under lease by Cheshire East Council. Since 1999, it has hosted North West England''s annual Royal Horticultural Society flower show.',-2.383913,53.330526,'https://upload.wikimedia.org/wikipedia/commons/thumb/1/10/Tatton_Hall_2009-2.jpg/1200px-Tatton_Hall_2009-2.jpg'),
(25,'King Street','Manchester, M2 6DE','King Street is one of the most important thoroughfares of Manchester city centre, England. For much of the 20th century it was the centre of the north-west banking industry but it has become progressively dominated by upmarket retail instead of large banks. Formerly known as St. James''s Square, this street was renamed after the defeat of the Jacobites in 1745. The top of the hill was home to Manchester''s first purpose-built theater and a concert hall.',-2.2473688,53.4810961,'https://mapartments.co.uk/uploads/transforms/0813e4e1d9aa9ea9a9d10f362d80e742/62150/King-Exterior_71ff2cc1d732d924b439258c143dfeeb.webp'),
(26,'Worsley Delph','Worsley, Manchester, M28 2GD','In 1759, construction began on a system of underground canals; they provided a route between Worsley Colliery and the Bridgewater Canal for the coal the colliery produced. The canals were used for this purpose until 1887 and closed shortly after the last coal pit in the area in 1968.',-2.3811,53.500961,'https://lh6.googleusercontent.com/proxy/Pxlkd3DIJGPx4h81kw8aloLTAEefe0g37wtmFqSNt5xbjuGR37P6jJaWgNhUQ5c2pjcGZdTuVQwxVM7zi3Zdk5KETV8TSOQj3DKVDZbQ37AYyi5dTdyyQ_TLCWaBhdJfwDWOgine8cbFk87fSojnAQBbLc523H5Hntr6AcgmZtze4Lv5Vq148A'),
(27,'Heaton Hall','Heaton Park, Prestwich, Manchester M25 2SW','Heaton Hall is a magnificent 18th-century country house set in the rolling landscape of Heaton Park. It was the family seat of the Egerton family and remains one of the North West''s most impressive and important buildings. ',-2.252501,53.536077,'https://eu-assets.simpleview-europe.com/staytripper/imageresizer/?image=%2Fdmsimgs%2F85D6417B710F5306D169180DA9714042DCABC214.jpg&action=ProductDetailPro'),
(28,'Quarry Bank Mill','Styal Rd, Styal, Wilmslow, SK9 4LA','Quarry Bank Mill (also known as Styal Mill) in Styal, Cheshire, England, is one of the best preserved textile factories of the Industrial Revolution. Built in 1784, the cotton mill is recorded in the National Heritage List for England as a designated Grade II* listed building. Quarry Bank Mill was established by Samuel Greg, and was notable for innovations both in machinery and also in its approach to labour relations, the latter largely as a result of the work of Greg''s wife, Hannah Lightbody. The family took a somewhat paternalistic attitude toward the workers, providing medical care for all and limited education to the children, but all laboured roughly 72 hours per week until 1847 when a new law shortened the hours. Greg also built housing for his workers, in a large community now known as Styal Estate. Some were conversions of farm houses, or older residences but 42 new cottages, including the Oak Cottages (now Grade II Listed), were built in the 1820s when the mill was being expanded. The National Trust, which runs the mill and Styal Estate as a museum that is open to the public, calls the site one of Britain''s greatest industrial heritage sites, home to a complete industrial community”. According to the Council of Europe, the mill with Styal village make up the most complete and least altered factory colony of the Industrial Revolution. It is of outstanding national and international importance',-2.249922,53.343682,'https://theladybirdsadventures.co.uk/wp-content/uploads/2018/01/styal-mill.jpg'),
(29,'St Mary’s Church','17 Mulberry St, Manchester, M2 6LN','Founded in 1794 The Hidden Gem was the first Catholic church built as a church after the Reformation. Within the church, the Adams Stations of the Cross are now considered one of the great art commissions of the 20th Century. ',-2.246404,53.480044,'https://hiddengem.me.uk/wp-content/uploads/2021/05/cropped-tempImageCLWNh0-2048x1536-1-1.jpg'),
(30,'Marple Lime Kilns','Lime Kiln Ln, Marple, Stockport SK6 6BX','Between 1797 and 1800, Samuel Oldknow built three lime kilns on the east side of the Peak Forest Canal. The kilns are 11 m (36 ft) deep and were built into the hillside. The site operated into the 20th century, and the remaining walling of the kilns is protected as a Grade II listed building.',-2.05748,53.392998,'https://oldknows.com/gallery-14.jpg'),
(31,'McConnel & Kennedy Mills','Redhill St, Manchester','McConnel & Kennedy Mills are a group of cotton mills on Redhill Street in Ancoats, Manchester, England. With the adjoining Murrays'' Mills, they form a nationally important group. The complex consists of six mills, Old Mill built in 1798, Long Mill from 1801 and Sedgewick Mill built between 1818 and 1820. A further phase of building in the early 20th century added Sedgewick New Mill in 1912, Royal Mill, originally the New Old Mill built in 1912 but renamed in 1942, and Paragon Mill also built in 1912. Paragon Mill, at eight storeys, was the world''s tallest cast iron structure when it was built.',-2.227075,53.483305,'https://cdn.ipernity.com/141/10/71/31071071.918f135d.640.jpg?r2'),
(33,'Marple Aqueduct','Marple, SK6 6QB','The Marple Aqueduct was built between 1794 and 1801 to carry the Peak Forest Canal over the River Goyt. The aqueduct is still in use for pleasure craft.',-2.068203,53.40722,'https://visitmarple.co.uk/photos/albums/uploads/new/souvenir/Image07.jpg'),
(34,'The Portico Library','57 Mosley St, Manchester, M2 3HY','The Portico Library, The Portico or Portico Library and Gallery on Mosley Street in Manchester, England, is an independent subscription library designed in the Greek Revival style by Thomas Harrison of Chester and built between 1802 and 1806. It is recorded in the National Heritage List for England as a Grade II* listed building and has been described as the most refined little building in Manchester”. It is home to 215 years of literature and culture in the heart of Manchester.',-2.240512,53.479609,'https://upload.wikimedia.org/wikipedia/commons/a/a8/Portico_Library%2C_Manchester.jpg'),
(35,'Peterloo Massacre Memorial','Windmill St, Manchester, M2 3DW','The Peterloo Memorial is a memorial in Manchester, England, commemorating the Peterloo Massacre. It is sited close to the site of the massacre and was unveiled on 14 August 2019.',-2.245651,53.476542,'https://carusostjohn.com/media/images/projects/peterloo-memorial-manchester-uk/nJKIF_PTIwJk_900x600.jpg'),
(36,'Blackfriars Bridge','Blackfriars St, Manchester, Salford, M3','Blackfriars Bridge is a stone arch bridge in Greater Manchester, England. Completed in 1820, it crosses the River Irwell, connecting Salford to Manchester. It replaced an earlier wooden footbridge, built in 1761 by a company of comedians who performed in Salford, and who wanted to grant patrons from Manchester access to their theatre. The old bridge was removed in 1817. The new design, by Thomas Wright of Salford, was completed in June 1820, and opened on 1 August that year. The bridge is built from sandstone and uses three arches to cross the river. To obscure the then badly polluted river from view, at some point in the 1870s its original stone balustrade was replaced with cast iron. In 1991 this was replaced with stone-clad reinforced concrete.',-2.248067,53.483902,'https://upload.wikimedia.org/wikipedia/commons/d/dd/Former_Fairburn_House_and_Blackfriars_Bridge%2C_Manchester.jpg'),
(37,'Manchester Art Gallery','Mosley St, Manchester, M2 3JL','Manchester Art Gallery is a publicly owned art museum on Mosley Street in Manchester city centre, England. The main gallery premises were built for a learned society in 1823 and today its collection occupies three connected buildings, two of which were designed by Sir Charles Barry. It houses many works of local and international significance and has a collection of more than 25,000 objects. More than half a million people visited the museum in the period of a year, according to figures released in April 2014.',-2.300278,53.594498,'https://www.creativetourist.com/app/uploads/2018/04/mag_front_Andrew_Brooks-copy.jpg'),
(38,'Manchester Liverpool Road Railway Station','Manchester, M3 4EQ','Liverpool Road is a former railway station on the Liverpool and Manchester Railway in Manchester, England; it opened on 15 September 1830. The station was the Manchester terminus of the world''s first inter-city passenger railway in which all services were hauled by timetabled steam locomotives. It is the world''s oldest surviving terminal railway station. With tracks running at a first floor level behind the building, it could also be considered one of the world''s first elevated railway stations.',-2.258059,53.477146,'https://upload.wikimedia.org/wikipedia/commons/f/f9/Liverpool_Road_station%2C_Manchester.jpg'),
(39,'Portland Basin Museum','Portland Pl, Ashton-under-Lyne, OL7 0QA','Portland Basin Museum is housed within the restored nineteenth century Ashton Canal Warehouse in Ashton-under-Lyne. The museum combines a lively modern interior with a peaceful canal side setting. The temporary exhibition takes a step back in time on the 1920s street, as the sights and sounds of bygone Tameside are brought to life. Visitors can explore the area''s industrial heritage and discover what life was like down the mines, or on the farm. Find out more about local crafts and industries and marvel at historic machines.',-2.100191,53.483226,'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/13/81/ee/d2/portland-basin-museum.jpg?w=1200&h=-1&s=1'),
(40,'Elizabeth Gaskell’s House','84 Plymouth Grove, Manchester, M13 9LW','Historic house and museum that celebrates the life and literature of Elizabeth Gaskell, one of the UK’s most important Victorian writers. A hands-on experience will introduce you to the world of the writer Elizabeth Gaskell and her family through historic period rooms, Victorian style garden, expert guides and changing exhibitions.',-2.221191,53.463724,'https://lancashirepast.com/wp-content/uploads/2024/03/20230723_112740-1.jpg'),
(41,'Picadilly Station','Manchester, M1 2WD','Manchester Piccadilly is the main railway station of the city of Manchester, in the metropolitan county of Greater Manchester, England. Opened originally as Store Street in 1842, it was renamed Manchester London Road in 1847 and became Manchester Piccadilly in 1960. Located to the south-east of the city centre, it hosts long-distance intercity and cross-country services to national and regional destinations and local commuter services around Greater Manchester. It is one of 19 major stations managed by Network Rail. The station has 14 platforms: 12 terminal and two through platforms (numbers 13 and 14). Piccadilly is also a major interchange with the Metrolink light rail system with two tram platforms in its undercroft.',-2.231128,53.476781,'https://cdn.prgloo.com/media/da4264c290a84c61b62fcfc232e65e04.jpg?width=1135&height=960'),
(42,'Victoria Railway Station','Manchester, M3 1WY','Manchester Victoria station in Manchester, England, is a combined mainline railway station and Metrolink tram stop. Situated to the north of the city centre on Hunts Bank, close to Manchester Cathedral, it adjoins Manchester Arena which was constructed on part of the former station site in the 1990s. Opened in 1844 and part of the Manchester station group, Manchester Victoria is Manchester''s second busiest railway station after Piccadilly, and is the busiest station managed by Northern.',-2.242544,53.487113,'https://upload.wikimedia.org/wikipedia/commons/e/ee/Manchester_Victoria_station_19-10-2009_12-11-47kopie.jpg'),
(43,'Bury Transport Museum','Bolton St Station, Castlecroft Goods Warehouse, Bury, BL9 0EY','Bury Transport Museum is housed within a Grade II listed ex-railway warehouse that dates from 1848. Restored to its former glory, it now houses a collection of vintage vehicles including buses, steam rollers and trams. Hands-on interactive exhibits explain the development of transport in the Northwest, how the Goods Warehouse was used and the types of materials that would have been handled here.',-2.300278,53.594498,'https://manchester.newmindmedia.com/wsimgs/Bury_Transport_Museum_small_818186798.jpg'),
(44,'Salford Museum & Art Gallery','Crescent, Salford, M5 4WU','Salford Museum and Art Gallery, in Peel Park, Salford, Greater Manchester, was the UK’s ‘first free public library’, which opened in January 1850, followed in November by a museum and art gallery. The gallery and museum are devoted to the history of Salford and Victorian art and architecture. The building was a mansion house known as Lark Hill, which had been built in the 1790s and has given its name to our famous Lark Hill Place; a Victorian street within the museum. Today, Salford Museum and Art Gallery presents an exciting programme of permanent displays and changing contemporary exhibitions together with a range of events and activities guaranteed to inspire which completes a must visit experience for individuals, families, schools and organisations to enjoy.',-2.271363,53.485107,'https://salfordmuseum.com/wp-content/uploads/sites/3/2023/10/Lark-Hill-Place-2023-WEB-2000x846.png'),
(45,'Hat Works Museum','Wellington Mill, Wellington Rd S, Stockport, SK3 0EU','The Hat Works is a museum in Stockport, Greater Manchester, England, which opened in 2000. It is the UK''s only museum dedicated to the hatting industry, hats and headwear. Before 2000, smaller displays of hatting equipment were exhibited in Stockport Museum and in the former Battersby hat factory. The building, Wellington Mill, was built as an early fireproof cotton spinning mill in 1830–1831 before becoming a hat works in the 1890s.',-2.161841,53.408565,'https://stockportoldtown.co.uk/wp-content/uploads/2017/08/hatworks_Bright-1024x681.jpg'),
(46,'Former Free Trade Hall','Peter St, Manchester, M2 5QR','The Free Trade Hall on Peter Street, Manchester, England, was constructed in 1853–56 on St Peter''s Fields, the site of the Peterloo Massacre. It is now a Radisson hotel. The hall was built to commemorate the repeal of the Corn Laws in 1846. The architect was Edward Walters. It was owned by the Manchester Corporation and was bombed in the Manchester Blitz; its interior was rebuilt and it was Manchester''s premier concert venue until the construction of the Bridgewater Hall in 1996. The hall was designated a Grade II* listed building in 1963.',-2.246788,53.477906,'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d2/The_Free_Trade_Hall%2C_Manchester.jpg/1200px-The_Free_Trade_Hall%2C_Manchester.jpg'),
(47,'Watts Warehouse','35 Portland St, Manchester, M1 3LA','Watts Warehouse is a large, ornate Victorian Grade II* listed building standing on Portland Street in the centre of Manchester, England. It opened in 1856 as a textile warehouse for the wholesale drapery business of S & J Watts, and was the largest single-occupancy textile warehouse in Manchester. Today the building is part of the Britannia Hotels chain.',-2.237537,53.479134,'https://upload.wikimedia.org/wikipedia/commons/8/81/Watts_Warehouse_Manchester.jpg'),
(48,'Silk Museum','Park Ln, Macclesfield, SK11 6TJ','The Silk Museum on Park Lane follows the full journey through the industrial process of silk making; explore silk from the cocoon to the loom. The 19th century Paradise Mill features working Jacquard silk handlooms in their original setting, and tours recreate the expertise and creative skills involved in silk production.',-2.124945,53.256173,'https://images.squarespace-cdn.com/content/v1/63cbc4d5367dab5a0d50e9ce/53fd126f-a864-46ae-b923-56b411a918ec/Paradise+Mill-10.jpg'),
(49,'Albert Square','Albert Square, Manchester, M2 5DB','Albert Square is a public square in the centre of Manchester, England. It is dominated by its largest building, the Grade I listed Manchester Town Hall, a Victorian Gothic building by Alfred Waterhouse. Other smaller buildings from the same period surround it, many of which are listed.  There are statues of Prince Albert, John Bright, Oliver Heywood, James Fraser and William Gladstone.',-2.244784,53.479388,'https://s0.geograph.org.uk/geophotos/02/12/08/2120812_39af309d_1024x1024.jpg'),
(50,'Abraham Lincoln Statue','Lincoln Grove, Manchester, M2 5LF','The Abraham Lincoln statue in Manchester holds an important historical significance beyond the recognition of the 16th President of the United States. Unveiled in 1919, it stands as a testament to a shared history between the United States and England, particularly the city of Manchester, during the American Civil War. In 1986 the Lincoln statue was moved from Platt Fields to become the focal point of a new public space, Lincoln Square, in the centre of Manchester. It was mounted on a new pedestal on which was engraved extracts from a letter written by Lincoln in 1863 to the working men of Lancashire recognising the sufferings they were undergoing in the war that was to result in the legal abolition of slavery in all of the states of the USA. ',-2.247097,53.479659,'https://www.wkiri.com/albums/1003-manchester/IMG_9184.jpg'),
(51,'Charter Street Ragged School and Working Girls Institute','Dantzic St, Manchester, M4 4DN','The Charter Street Ragged School and Working Girls Home sits on the corner of Dantzic Street and Little Nelson Street.  This was the site of the first industrial school in Manchester which opened in 1847.',-2.236665,53.489609,'https://external-preview.redd.it/u23WQWE47_qGhTdzCIAKmE2mAakiNAM8rTgAW5Rhwjc.jpg?auto=webp&s=1bb5daede55dc2b830e6c1867f39cef151020f5b'),
(52,'Printworks','27 Withy Grove, Manchester, M4 2BS','Printworks is an urban entertainment venue offering a cinema, clubs and eateries, located on the corner of Withy Grove and Corporation Street in Manchester city centre, England. It is located on the revamped site of the business premises of the 19th-century newspaper proprietor Edward Hulton, established in 1873 and later expanded.',-2.241994,53.485136,'https://assets.simpleviewinc.com/simpleview/image/fetch/c_fill,f_jpg,h_822,q_75,w_1220/http://manchester.newmindmedia.com/wsimgs/Printworks_1_1__623022962.jpg'),
(53,'Royal Exchange Theatre','St Ann''s Square, Manchester, M2 7DH','The Royal Exchange Theatre is an iconic, spaceship-like theatre-in-the-round found in a grade II listed building in the city centre on the land bounded by St Ann''s Square, Exchange Street, Market Street, Cross Street and Old Bank Street. The Royal Exchange building was heavily damaged in the Manchester Blitz and in the 1996 Manchester bombing.',-2.244071,53.482545,'https://www.manchestertheatrehistory.co.uk/wp-content/uploads/2021/08/royal-exchange-3.jpg'),
(54,'The University of Manchester','Oxford Rd, Manchester, M13 9PL','The University of Manchester is a public research university in Manchester, England. The main campus is south of Manchester City Centre on Oxford Road. The university owns and operates major cultural assets such as the Manchester Museum, The Whitworth art gallery, the John Rylands Library, the Tabley House Collection and the Jodrell Bank Observatory – a UNESCO World Heritage Site. The University of Manchester is considered a red brick university, a product of the civic university movement of the late 19th century. The current University of Manchester was formed in 2004 following the merger of the University of Manchester Institute of Science and Technology (UMIST) and the Victoria University of Manchester.  This followed a century of the two institutions working closely with one another.',-2.234055,53.466818,'https://manchester.newmindmedia.com/wsimgs/the-university-of-manchester-min_1219152588.jpg '),
(55,'Manchester Central','Windmill St, Manchester, M2 3GX','Manchester Central Convention Complex (commonly known as Manchester Central or GMEX (Greater Manchester Exhibition Centre)) is an exhibition and conference centre converted from the former Manchester Central railway station in Manchester, England. The building has a distinctive arched roof with a span of 64 metres (210 ft) – the second-largest railway station roof span in the United Kingdom, and was granted Grade II* listed building status in 1963. After 89 years as a railway terminus, it closed to passengers in May 1969. It was renovated as an exhibition centre formerly known as the G-Mex Centre in 1982 and was Manchester''s primary music concert venue until the construction of the Manchester Arena. After renovation the venue reverted to its former name Manchester Central in 2007.',-2.246395,53.476967,'https://upload.wikimedia.org/wikipedia/commons/a/a8/Manchester_Central_Arena.jpg'),
(56,'Manchester Museum','Oxford Rd, Manchester, M13 9PL','Manchester Museum is a museum displaying works of archaeology, anthropology and natural history and is owned by the University of Manchester, in England. Sited on Oxford Road (A34) at the heart of the university''s group of neo-Gothic buildings, it provides access to about 4.5 million items from every continent. It is the UK’s largest university museum and serves both as a major visitor attraction and as a resource for academic research and teaching. It has around 430,000 visitors each year.',-2.234094,53.466578,'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/The_Manchester_Museum.jpg/1200px-The_Manchester_Museum.jpg'),
(57,'The Whitworth Art Gallery','Oxford Rd, Manchester, M15 6ER','The Whitworth is an art gallery in Manchester, England, containing over 60,000 items in its collection. The gallery is located in Whitworth Park and is part of the University of Manchester.',-2.228554,53.460479,'https://d3d00swyhr67nd.cloudfront.net/w800h800/WHAG_location_image_1.jpg'),
(58,'Peel Hall','Peel Park Campus, Salford, M5 4WT','Peel Hall is one of a few remaining Gothic concert halls in the United Kingdom. It has tiered seating for 370 and is housed in the Peel Building which stands at the front of the Peel Park Campus.',-2.270819,53.489508,'https://ourpass.co.uk/wp-content/uploads/2020/07/peel_hall_manchester.jpg'),
(59,'John Rylands Library','Manchester, M13 9PP','The John Rylands Research Institute and Library is a late-Victorian neo-Gothic building on Deansgate in Manchester, England. It is part of the University of Manchester. The library, which opened to the public in 1900, was founded by Enriqueta Augustina Rylands in memory of her husband, John Rylands. It became part of the university in 1972, and now houses the majority of the Special Collections of The University of Manchester Library, the third largest academic library in the United Kingdom.',-2.248745,53.480187,'https://unlockmanchester.com/public/images/content/john-rylands-lbrary.jpg'),
(60,'The Pankhurst Centre','60-62 Nelson St, Manchester, M13 9WP','The Pankhurst Centre, 60–62 Nelson Street, Manchester, England, is a pair of Victorian villas, of which No. 62 was the home of Emmeline Pankhurst and her daughters Sylvia, Christabel and Adela and the birthplace of the suffragette movement in 1903. The first meeting of the movement that became known as the suffragettes took place in the parlour of this house! ',-2.227363,53.463069,'https://manchester.newmindmedia.com/wsimgs/2._The_Pankhurst_Centre_Pankhurst_Trust_658677662.jpg'),
(61,'The Midland Hotel','16 Peter St, Manchester, M60 2DS','The Midland Hotel is a grand hotel in Manchester, England. Opened in 1903, it was built by the Midland Railway to serve Manchester Central railway station, its northern terminus for its rail services to London St Pancras. It faces onto St Peter''s Square. The hotel was designed by Charles Trubshaw in Edwardian Baroque style and is a Grade II* listed building.',-2.244929,53.477689,'https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Midland_Hotel_west%2C_Manchester.jpg/1200px-Midland_Hotel_west%2C_Manchester.jpg'),
(62,'Emmeline Pankhurst Statue','Manchester, M2 3AA','Rise up, Women, also known as Our Emmeline is a bronze sculpture of Emmeline Pankhurst in St Peter''s Square, Manchester. Pankhurst was a British political activist and leader of the suffragette movement in the United Kingdom. Hazel Reeves sculpted the figure and designed the Meeting Circle that surrounds it. The statue was unveiled on 14 December 2018, the centenary of the 1918 United Kingdom general election, the first election in the United Kingdom in which women over the age of 30 could vote. It is the first statue honouring a woman erected in Manchester since a statue of Queen Victoria was dedicated more than 100 years ago.',-2.242978,53.477872,'https://lindagge.com/wp-content/uploads/2019/02/emmeline-pankhurst-statue1.jpg'),
(63,'Victoria Baths','Hathersage Rd, Manchester, M13 0FE','Victoria Baths is a Grade II* listed building, in the Chorlton-on-Medlock area of Manchester, England. The baths opened to the public in 1906 and cost £59,144 to build. Manchester City Council closed the baths in 1993 and the building was left empty. It is widely recognised as Britain’s finest historic municipal swimming pool. From the iconic green tiles and beautful stained glass, to the vaulted ceilings and other period features you won’t find anywhere else.',-2.216342,53.459826,'https://offloadmedia.feverup.com/secretmanchester.com/wp-content/uploads/2022/08/22091623/Victoria_Baths-Manchester-360.jpg'),
(64,'Old Trafford Stadium','Sir Matt Busby Way, Old Trafford, Stretford, Manchester, M16 0RA','Old Trafford is a football stadium in Old Trafford, Greater Manchester, England, and is the home of Manchester United. With a capacity of 74,310,  it is the largest club football stadium (and second-largest football stadium overall after Wembley Stadium) in the United Kingdom, and the twelfth-largest in Europe.',-2.289656,53.463717,'https://i.ebayimg.com/00/s/MTA2NlgxNjAw/z/PU4AAOSwqAFkHbY8/$_57.JPG?set_id=8800005007'),
(65,'Former Albert Hall','27 Peter St, Manchester, M2 5QR','The Albert Hall is a music venue in Manchester, England. Built as a Methodist central hall in 1908 by the architect William James Morley of Bradford and built by J. Gerrard & Sons Ltd of Swinton, it has been designated by English Heritage as a Grade II listed building. The main floor was used as a nightclub from 1999 to 2011. The second floor, the Chapel Hall, unused since 1969, was renovated in 2012–14 for music concerts.',-2.247805,53.478111,'https://upload.wikimedia.org/wikipedia/commons/c/cf/Albert_Hall%2C_Manchester.jpg'),
(66,'IWM North','Trafford Wharf Rd, Trafford Park, Stretford, Manchester, M17 1TZ','Imperial War Museum North (sometimes referred to as IWM North) is a museum in the Metropolitan Borough of Trafford in Greater Manchester, England. One of five branches of the Imperial War Museum, it explores the impact of modern conflicts on people and society. It is the first branch of the Imperial War Museum to be located in the north of England. The museum occupies a site overlooking the Manchester Ship Canal on Trafford Wharf Road, Trafford Park, an area which during World War II was a key industrial centre and consequently heavily bombed during the Manchester Blitz in 1940.',-2.299127,53.469442,'https://www.iwm.org.uk/sites/default/files/2017-12/iwm0060-web.jpg'),
(67,'Victory Over Blindness WW1 Memorial','Manchester Piccadilly Station, Manchester','On 16 October 2018, a statue to commemorate the amazing achievements of the blind veterans we have supported since the First World War was unveiled. The statue, entitled Victory Over Blindness, depicts seven blinded First World War soldiers leading one another away from the battlefield with their hand on the shoulder of the man in front. Realised by artist and sculptor Johanna Domke-Guyot, it stands proudly outside Manchester Piccadilly station as the only permanent memorial to the injured of that conflict.',-2.231366,53.477832,'https://upload.wikimedia.org/wikipedia/commons/7/7f/Victory_Over_Blindness%2C_Manchester_%281%29.jpg'),
(68,'Manchester Cenotaph','Manchester, M2 5PD','A Portland stone memorial by Edwin Lutyens, the central feature of which is a prone figure of a fighting man covered by his greatcoat. On each of the flank sides is carved the City of Manchester coat of arms encircled by large laurel wreaths, bound and supported by ribbons. On each of the ends are swords in enriched sheaths and the Imperial Crown in bold relief. To the sides of the cenotaph are two obelisks, on which the dates of the Great War are incised within laurel wreathes on the front and rear faces of each. After WW2 the dates of that conflict were inscribed on the side walls of each obelisk. To the front is the Great War Stone, a replica of the Stone of Remembrance, it rests on a surround of three steps. A Garden of Remembrance (WMR 100981) was added after World War 2, within which later commemorative plaques were installed. In 2014 the memorial structures, which were aligned roughly West to East, were dismantled and moved across St Peter''s Square, and aligned roughly South to North, as part of an extensive reorganisation and rebuilding project prompted by the need for more space to accommodate the infrastructure for the city''s enlarged tram system.',-2.24314,53.478759,'https://upload.wikimedia.org/wikipedia/commons/thumb/5/5a/Manchester_Cenotaph_November_2014.jpg/640px-Manchester_Cenotaph_November_2014.jpg'),
(69,'Manchester Central Library','St Peter''s Square, Manchester, M2 5PD','Manchester Central Library is the headquarters of the city''s library and information service in Manchester, England. Facing St Peter''s Square, it was designed by E. Vincent Harris and constructed between 1930 and 1934. The form of the building, a columned portico attached to a rotunda domed structure, is loosely derived from the Pantheon, Rome',-2.243859,53.478056,'https://static.loadstodo.co.uk/app/uploads/2020/05/Manchester-Central-Library.jpg'),
(70,'The Fusilier Museum','Moss St, Bury, BL9 0DF','The Fusilier Museum is home to the collections of the XX Lancashire Fusiliers and the Royal Regiment of Fusiliers.  Together they record over 300 years of history and heritage of the people who served and continue to serve in the regiments. The museum is made up of two main galleries - The Lancashire Fusiliers (LF) and The Royal Regiment of Fusiliers (RRF). The LF gallery tells the story of the 20th Regiment of Foot and the Lancashire Fusiliers from 1688 to 1968, when they then became part of The Royal Regiment of Fusiliers.  The RRF gallery continues the story for the Regiment right up to the present day with a closer look at more recent conflicts in Northern Ireland, Bosnia and Afghanistan.',-2.298589,53.592062,'https://upload.wikimedia.org/wikipedia/commons/0/08/Fusilier_Museum_Bury_April_2017.jpg'),
(71,'Stockport Air Raid Shelters','61 Chestergate, Stockport, SK1 1NE','The Stockport Air Raid Shelters are a system of almost 1 mile (1.6 km) of underground air-raid shelters dug under Stockport, 6 miles (9.7 km) south of Manchester, during World War II to protect local inhabitants during air raids. The museum provided visitors with the opportunity to experience life as it was during a ''black out'' in wartime Britain.',-2.159606,53.41033,'https://offloadmedia.feverup.com/secretmanchester.com/wp-content/uploads/2024/06/27174326/stockport-air-raid-shelters.jpg'),
(72,'Alan Turing Memorial','Sackville St, Manchester, M1 3HB','Alan Turing was a pioneer who’s ideas led to early versions of modern computing and helped win World War II. The Alan Turing statue was unveiled on 23rd June 2001. Turing has been depicted by sculptor Glyn Hughes as a scruffily dressed, ordinary man, holding an apple. The apple represents Newton, the tree of knowledge and forbidden love as well as being a reminder of Turing’s death. Hughes buried his old Amstrad computer under the plinth as a tribute to “the Godfather of all modern computers”.',-2.236126,53.47665,'https://lindagge.com/wp-content/uploads/2019/04/alan-turing-memorial1.jpg?w=640'),
(73,'Jodrell Bank','Crewe, CW4 8BU','Jodrell Bank Observatory in Cheshire, England hosts a number of radio telescopes as part of the Jodrell Bank Centre for Astrophysics at the University of Manchester. The observatory was established in 1945 by Bernard Lovell, a radio astronomer at the university, to investigate cosmic rays after his work on radar in the Second World War. It has since played an important role in the research of meteoroids, quasars, pulsars, masers, and gravitational lenses, and was heavily involved with the tracking of space probes at the start of the Space Age.',-2.305296,53.2309,'https://pickmerehouse.co.uk/wp-content/uploads/2024/06/Jodrell-Bank.jpg'),
(74,'Chetham’s School of Music','Long Millgate, Manchester, M3 1SB','Chetham''s School of Music is a private co-educational boarding and day music school in Manchester, England. Chetham''s educates pupils between the ages of 8 and 18, all of whom enter via musical auditions. The music school was established in 1969 from Chetham''s Hospital School, founded as a charity school by Humphrey Chetham in 1653. After becoming a boys'' grammar school in 1952, the school turned to music as its speciality, at the same time becoming a private school and accepting its first female students. The oldest parts of the school date to the 1420s, when the building was constructed as a residence for priests of the church which is now Manchester Cathedral. Academic and music teaching moved into a new, building in 2012; this replaced the Victorian Palatine building and allowed easier access for concert visitors. A 482-seat concert hall, Stoller Hall, opened within the New School Building in 2017.',-2.243123,53.486171,'https://lh5.googleusercontent.com/proxy/BhU-_TL_uVsF-yRQxSi1f-KP-k_hCwGuLIg-FwHtHA5uolcl_Xl8OPx0vy87BUaDXOZE31U74jJvEFXEwcgRJnISoA-pXsTMuZa_cvsFdSzYXWiwyfluwfNQGNsUkDUD6ReGXuzLbpAQkO4'),
(75,'Museum of Transport','Boyle St, Cheetham Hill, Manchester, M8 8UW','Greater Manchester''s Museum of Transport aims to preserve and promote the public transport heritage of Greater Manchester in North West England. It has one of the largest collections of its kind in the country and is run by the volunteers of the Greater Manchester Transport Society. The Museum is based in one of Manchester''s earliest bus garages, adjoining the first tram depot.',-2.233944,53.503074,'https://motgm.uk/assets/img/image_21691.jpg'),
(76,'Greater Manchester Police Museum','57A Newton St, Manchester, M1 1ET','The Greater Manchester Police Museum and Archives enables you to experience what life was really like for officers, in what was once a busy Victorian Police Station. You’ll also see how times have changed and how policing has evolved to meet today’s needs. Located in the historic Northern Quarter of Manchester, the museum was one of the city''s earliest police stations and has been lovingly restored to reflect the reality of policing in the late 1800''s/ 1900''s. See where Manchester''s criminals were charged, fingerprinted and discover the cells that were often packed with twelve men on a busy night. Why not have a seat on the cell beds with their wooden pillows! The Museum was founded in 1981 and is funded by Greater Manchester Police, it not only collects and preserves archive material and objects relating to the history of policing in the Greater Manchester area, but acts as an important resource for community engagement, where visitors can talk to staff and volunteers about policing. GMP Museum holds primary and secondary source information about the history and development Greater Manchester policing. Archive holdings are a mix of records – both official and personal.',-2.232291,53.482351,'https://manchester.newmindmedia.com/wsimgs/Police%20Museum%283%29.jpg'),
(77,'Castlefield Urban Heritage Park','Duke St, Manchester','The site of an early Roman fort, the district of Castlefield has been beautifully restored into a 7-acre urban park with canal-side walks, landscaped open spaces, and refurbished warehouses.',-2.254016,53.475675,'https://media1.thrillophilia.com/filestore/uf7b3wlhlqspkob8r1zvd7qwhoi3_1618660339_shutterstock_1548778544.jpg'),
(78,'Science and Industry Museum','Liverpool Rd, Manchester, M3 4JP','Explore 250 years of innovations and ideas that started life in Manchester and went on to change the world on a visit to the Science and Industry Museum. Journey through Manchester’s rich legacy of ideas and discoveries in the Revolution Manchester Gallery, from the ancestor of modern computing to one of the first Rolls-Royce motorcars. Find out how the city''s heritage is interwoven with the cotton industry in the Textiles Gallery. Follow the textiles story through innovations in design, printing and finishing, and find out how ‘Cottonopolis’ changed the world we all live in today. Get hands on and see science brought to life in Experiment, an interactive gallery designed for the whole family to enjoy together.',-2.254145,53.477078,'https://cdn.rt.emap.com/wp-content/uploads/sites/4/2024/08/12145755/Science-and-Industry-Museum-Image-by-Nina-Alizada-Shutterstock2.jpg'),
(79,'Fireground Museum','Maclure Rd, Rochdale, OL11 1DN','The Museum tells the story of firefighting, particularly in the Greater Manchester region. The area has played a significant role in the story of fire brigades and fire engineering. Manchester formed England’s first municipal fire service in 1826, whilst the country’s earliest motorised fire engine was delivered to Eccles in 1901.',-2.154295,53.611274,'https://www.fireground.org.uk/site/assets/files/1/images.jpg'),
(80,'Chinatown','41 Faulkner St, Manchester, M1 4EE','Chinatown in Manchester, England, is the second largest Chinatown in the United Kingdom and the third largest in Europe. Its archway was completed in 1987 on Faulkner Street in Manchester city centre, which contains Chinese, Japanese, Korean, Nepali, Malaysian, Singaporean, Thai and Vietnamese restaurants, shops, bakeries and supermarkets. It is the centre of the city’s Chinese community. The annual Chinese New Year festival, in February, is a highlight in the Manchester events calendar, it includes stalls and dancing Dragons in the famous parade.',-2.239885,53.478355,'https://manchesterchinesecentre.org.uk/wp-content/uploads/2020/06/981d3a2f74dd94b01b61ed37a987cc0.png'),
(81,'Vimto Monument','Vimto Park, Manchester, M1 3BU','A giant wooden soda bottle pays homage to a distinctly British drink on the very spot where it was invented. Installed in 1992 the oversized monument consists of a giant Vimto bottle surrounded at its base by outsized versions of some of the fruits and herbs used in the drink’s production, all carved out of sustainable wood.',-2.234543,53.475559,'https://d3d00swyhr67nd.cloudfront.net/w1200h1200/collection/GMIII/UOM/GMIII_UOM_UMC_2016_409-001.jpg'),
(82,'Bridgewater Hall','Lower Mosley St, Manchester, M2 3WS','The Bridgewater Hall is Manchester’s international concert venue, built to give the best possible space for music. The Hall was opened in September 1996 and hosts over 300 performances a year including classical music, rock, pop, jazz, world music and much more. The Hall is home to the Hallé orchestra, and also hosts the BBC Philharmonic regularly. The Hall also programmes its own classical music season, the International Concert Series. The Hall works with a range of promoters and charity hirers on other programming.',-2.246565,53.475124,'https://designmcr.com/wp-content/uploads/2018/07/DM_Bridgewater_Hall_1-1800x1200.jpg'),
(83,'The Lowry','Pier, 8 The Quays, Salford, Manchester, M50 3AZ','The Lowry is a theatre and gallery complex at Salford Quays, Salford, Greater Manchester, England. It is named after the early 20th-century painter L. S. Lowry, known for his paintings of industrial scenes in North West England. The complex opened on 28 April 2000 and was officially opened on 12 October 2000 by Queen Elizabeth II.',-2.294961,53.470818,'https://upload.wikimedia.org/wikipedia/commons/0/0d/The_Lowry_main_entrance.jpg'),
(84,'Etihad Stadium','Etihad Campus, Manchester, M11 3FF','The City of Manchester Stadium, currently known as Etihad Stadium for sponsorship reasons, is the home of Premier League club Manchester City, with a domestic football capacity of 53,600, making it the 7th-largest football stadium in England and 11th-largest in the United Kingdom. Built to host the 2002 Commonwealth Games, the stadium has since staged the 2008 UEFA Cup final, England football internationals, rugby league matches, a boxing world title fight, the England rugby union team''s final group match of the 2015 Rugby World Cup and summer music concerts during the football off-season.',-2.200105,53.481918,'https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Manchester_city_etihad_stadium_%28cropped%29.jpg/1200px-Manchester_city_etihad_stadium_%28cropped%29.jpg'),
(85,'Beetham Tower','301 Deansgate, Manchester, M3 4LQ','Beetham Tower (also known as the Hilton Tower) is a 47-storey mixed use skyscraper in Manchester, England. Completed in 2006, it is named after its developers, the Beetham Organisation, and was designed by SimpsonHaugh and Partners. The development occupies a sliver of land at the top of Deansgate and was proposed in July 2003, with construction beginning a year later. At a height of 169 m (554 ft), it was described by the Financial Times as the UK''s first proper skyscraper outside London”. From 2006 to 2018, the skyscraper was the tallest building in Manchester and outside London in the United Kingdom. As a result of the elongated floor plan, the structure is one of the thinnest skyscrapers in the world with a height to width ratio of 10:1 on the east–west façade, but is noticeably wider on the north–south façade. A 4 m (13 ft) cantilever marks the transition between hotel and residential use on the north façade, and a blade structure on the south side of the building acts as a façade overrun accentuating its slim form and doubles as a lightning rod. The skyscraper is visible from ten English counties on a clear day.',-2.250283,53.475651,'https://i2-prod.manchestereveningnews.co.uk/incoming/article11113686.ece/ALTERNATES/s1200d/JS74301187-1.jpg'),
(86,'People’s History Museum','Left Bank, Manchester, M3 3ER','The People''s History Museum (the National Museum of Labour History until 2001) in Manchester, England, is the United Kingdom''s national centre for the collection, conservation, interpretation and study of material relating to the history of working people in the UK. It is located in a Grade II listed, former hydraulic pumping station on the corner of Bridge Street and Water Street designed by Manchester Corporation city architect, Henry Price.(',-2.252547,53.481476,'https://www.creativetourist.com/app/uploads/2016/08/Peoples-History-Museum-Spinningfields-Manchester-%C2%A9-phm.org_.uk_.jpg'),
(87,'Media City UK','MediaCity UK, M50 2NT','MediaCity is an iconic waterfront destination that''s part of Salford Quays in Salford, Greater Manchester. It’s a place bursting with creativity and culture, boasting one of the UK’s most visited arts attractions - The Lowry as well as the Imperial War Museum North. It’s home to BBC and ITV including Coronation Street and its famous cobbled set while dock10 attracts TV show audiences all year round thanks to the many shows filmed here including The Voice and Countdown.',-2.298844,53.472491,'https://www.mediacityuk.co.uk/wp-content/uploads/2021/09/MediaCityUK-July-2013-2-scaled.jpg'),
(88,'National Football Museum','Todd St, Manchester, M4 3BG','The museum tells the history of workers'' rights and democracy in Great Britain and about people''s lives at home, work and leisure over the last 200 years. The collection contains printed material, physical objects and photographs of people at work, rest and play. Some of the topics covered include popular radicalism, the Peterloo Massacre, 19th century trade unionism, the women''s suffrage movement, dockers, the cooperative movement, the 1945 general election, and football. It also includes material relating to friendly societies, the welfare movement and advances in the lives of working people.',-2.241908,53.48593,'https://www.whatsoninmanchester.com/wp-content/uploads/2017/06/national-football-museum.jpg')
];

    FOREACH m IN ARRAY arr LOOP
        INSERT INTO markers (marker_id, title, address, description, longitude, latitude, image, user_id)
            VALUES 
                (m.mark_id, m.title, m.address, m.description, m.long, m.lat, m.image, (CASE WHEN RANDOM() < 0.3 THEN NULL ELSE (SELECT user_id FROM profiles ORDER BY RANDOM() LIMIT 1) END))
            ;
    END LOOP;

    PERFORM setval('markers_marker_id_seq', (SELECT MAX(marker_id) FROM public.markers));
END $$;

DROP TYPE temp_marker_type;
-- SEED MARKERS --- END

-- SEED CATEGORIES --- START
INSERT INTO categories (category_id, name, grouping, positioning)
  VALUES
  (1,'Building','Type',1),
(2,'Museum','Type',2),
(3,'Gallery','Type',3),
(4,'Library','Type',4),
(5,'Theatre','Type',5),
(6,'Church','Type',6),
(7,'Station','Type',7),
(8,'Stadium','Type',8),
(9,'Observatory','Type',9),
(10,'Archaeological Site','Type',10),
(11,'Park','Type',11),
(12,'Bridge','Type',12),
(13,'Memorial','Type',13),
(14,'Statue','Type',14),
(15,'Famous People','Type',15),
(16,'Ice Age','Era',1),
(17,'Iron Age','Era',2),
(18,'Roman','Era',3),
(19,'Anglo Saxon','Era',4),
(20,'Medieval','Era',5),
(21,'Tudor','Era',6),
(22,'Stuart','Era',7),
(23,'Georgian','Era',8),
(24,'Industrial Revolution','Era',9),
(25,'Victorian','Era',10),
(26,'Edwardian','Era',11),
(27,'World Wars','Era',12),
(28,'20th Century','Era',13),
(29,'21st Century','Era',14)
;
-- SEED CATEGORIES --- END

-- SEED MARKERS CATEGORIES --- START
INSERT INTO markers_categories (marker_id, category_id)
VALUES
(2,10),
(3,10),
(4,10),
(5,10),
(6,10),
(7,1),
(8,1),
(9,1),
(10,12),
(11,6),
(11,1),
(12,1),
(13,1),
(14,2),
(14,1),
(15,10),
(16,1),
(17,1),
(18,1),
(19,11),
(19,1),
(20,1),
(21,11),
(21,1),
(22,12),
(23,6),
(23,1),
(24,11),
(24,1),
(25,1),
(26,10),
(27,11),
(27,1),
(28,1),
(29,6),
(29,1),
(30,10),
(31,1),
(33,12),
(34,4),
(34,1),
(35,13),
(36,12),
(37,3),
(37,1),
(38,7),
(38,1),
(39,2),
(40,15),
(40,1),
(41,7),
(42,7),
(43,2),
(44,2),
(45,2),
(45,1),
(46,1),
(47,1),
(48,2),
(49,1),
(49,14),
(50,14),
(50,15),
(51,1),
(52,1),
(53,5),
(53,1),
(54,1),
(55,1),
(55,7),
(56,2),
(56,1),
(57,3),
(57,1),
(58,1),
(59,4),
(59,1),
(60,15),
(60,1),
(61,1),
(62,14),
(62,15),
(63,1),
(64,8),
(65,1),
(66,2),
(66,1),
(67,13),
(67,14),
(68,13),
(69,4),
(69,1),
(70,2),
(71,2),
(72,14),
(72,15),
(73,9),
(74,1),
(75,2),
(76,2),
(76,1),
(77,10),
(78,2),
(78,1),
(79,2),
(80,1),
(81,14),
(82,1),
(83,5),
(83,1),
(84,8),
(85,1),
(86,2),
(87,1),
(88,2),
(88,1)
;
-- SEED MARKERS CATEGORIES --- END

-- SEED VOTES --- START
DO $$
DECLARE
  uid UUID;
  mid INT;
  lim INT;
  val INT;
BEGIN
  FOR uid IN (SELECT user_id FROM profiles) LOOP
    lim := (SELECT random() * 50)::int;

    IF lim = 0 THEN
        lim := 1;
    END IF;

    FOR mid IN (SELECT marker_id FROM markers ORDER BY random() LIMIT lim) LOOP
      val := (SELECT random() * 5)::int;

      IF val = 0 THEN
          val := 1;
      END IF;

      INSERT INTO votes (user_id, marker_id, value)
        VALUES (uid, mid, val)
      ;
    END LOOP;
  END LOOP;
END $$;
-- SEED VOTES --- END

-- SEED PLANNERS --- START
DO $$
DECLARE
  pid INT;
  mid INT;
  lim INT;
BEGIN
  FOR pid IN (SELECT planner_id FROM planners) LOOP
    lim := (SELECT random() * 8)::int;

    IF lim = 0 THEN
        lim := 1;
    END IF;

    FOR mid IN (SELECT marker_id FROM markers ORDER BY random() LIMIT lim) LOOP
      INSERT INTO planners_markers (planner_id, marker_id)
        VALUES (pid, mid)
      ;
    END LOOP;
  END LOOP;
END $$;
-- SEED PLANNERS --- END