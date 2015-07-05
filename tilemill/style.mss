Map {
  background-color: hsla(0,0%,100%,0.2);
}


/*#countries {
  ::outline {
    line-color: #85c5d3;
    line-width: 2;
    line-join: round;
  }
  polygon-fill: #fff;
}
*/
#greattrails { 
  line-width:4;
  line-color:red;
  line-opacity:0.8;
  line-cap:round;
  line-join:round;
}

#rectrails {
  line-width:2;
  line-color:lightblue;
  line-opacity:0.7;
  line-cap:round;
  line-join:round;
}

#interaction{
  line-opacity:0;
  line-width:6;
  [source = 'Community-submitted cycling route'] {
    line-width: 2;
  }
  line-cap:round;
  line-join:round;
  // this is all about trying to merge a point dataset with a 
  // line one for a single interactivity layer
  [id < 0] { 
    marker-width:8;
    marker-fill-opacity:0;
    marker-opacity:0;
  }
}

#biketrails::carpet {
  line-width:4;
  line-color:hsla(0,0,100%,60%);
  line-cap:round;
  line-join:round;
  line-smooth:0.2;

  [source = 'Community-submitted cycling route'] {
    line-width:2;
  }


}
#biketrails {  
  line-width:3;
  [zoom <= 11] { line-width: 1.5; }
  line-color:hsl(210,80%,50%);
  line-cap:round;
  line-join:round;
  line-smooth:0.2;
  [source = 'Community-submitted cycling route'] {
    line-color: hsl(180,60,50%);
    line-width:1;
    line-opacity:0.5;
  }
  [source = 'Community-submitted cycling advice'] {
    line-color: hsl(150,60,50%);
    line-width:1.5;
  }
}


#walkingtrails::carpet {
  line-width:4;
  line-color:hsla(0,0,100%,60%);
  line-cap:round;
  line-join:round;
  line-smooth:0.2;
}
#walkingtrails {
  line-width:2;
  line-color:hsl(20,80%,50%);
  line-cap:round;
  line-join:round;
  line-smooth:0.2;
}

#allsites[camping='yes']::underlay {
  marker-type:ellipse;
  marker-fill:hsla(60,100%,90%,80%);
  marker-width:12;
  marker-allow-overlap:true;
  marker-line-color: darkred;
  [source='OpenStreetMap'] {
    marker-line-width:0;
  }
}

#allsites[camping='yes'] {
  
  marker-file:url('https://raw.githubusercontent.com/mapbox/maki/mb-pages/renders/campsite-24@2x.png');
  marker-width:12;  
  marker-allow-overlap:true;
  marker-ignore-placement:true;
  [zoom >= 12] { marker-width:24; }  
}


#allsites[camping='yes'][zoom >= 10][site_class != '']::stars {
  text-name: '';
  [site_class='VERY BASIC'] { text-name: "'★'" }
  [site_class='BASIC'] { text-name: "'★★'"; }
  [site_class='MID'] { text-name: "'★★★'"; }
  [site_class='HIGH'] { text-name: "'★★★★'" }
  [site_class='VERY HIGH'] { text-name: "'★★★★★'" }

  text-face-name:'DejaVu Sans Book';
  text-dx:4;
  text-size:8;
  text-halo-fill:hsla(60,100%,55%,80%);
  text-halo-radius:1;
  text-fill:#333;
    text-allow-overlap:true;
  [zoom >= 12] { 
    text-dx: 8; text-size: 14;
    text-allow-overlap:true;
    text-halo-radius:2;
    text-size:10;
  }
  text-placement-type: simple;
  text-placements: 'E,W';


}