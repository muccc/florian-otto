use <threads.scad>;

eps=0.05;
$fn=32;

/* [Capsule] */

//outer diameter of the CO2-Capsule
cap_od = 22;

//height of the capsule body
cap_body_h = 82;

//height of the capsule thread
cap_thread_h = 11;

//diameter of the capsule thread
cap_thread_d = 9;

/* [Capsule Cage] */

//offset to the inner diameter of the cage 
cage_id_offset = 1.5;

//cage inner diameter
cage_id = cap_od + cage_id_offset;

//cage wall thickness
cage_wall = 2;

//cage outer diameter
cage_od = cage_id + 2* cage_wall;

//height of the capsule cage
cage_h=40;

//size of the cage clutch parts
cage_clutch_size=5;

//height of the top/screw part
cage_screw_h = 10;

//height of the clutch part;
cage_clutch_h=cage_h-cage_screw_h;

//diameter of the cage screw holes
cage_hole_d=2.5;

//z height of the screw holes
cage_hole_z = cage_h-cage_screw_h/2;

/* [Cage Driver] */

//height of of the driver shaft
driver_shaft_h = 10;

//inner diameter of the driver shaft
driver_shaft_id = 7;

//outer diameter of the driver shaft adapter
driver_shaft_od = 16;

//reduction of diameter on the flat surface of the motor drive shaft
driver_shaft_flatness = 1;

//diameter of the driver shaft screw holes;
driver_shaft_hole_d = 2.5;

//thickness of the driver clutch wall
driver_clutch_wall = 1;

//height of the driver clutch
driver_clutch_h = cage_clutch_h;

//driver clutch diameter offset
driver_clutch_fit = 2;

//inner diameter of the driver clutch
driver_clutch_id = cage_od+driver_clutch_fit;

//outer diameter of the driver clutch]) cylinder(d1=cage_od, d2=cage_od+cage_clutch_size+2, h=3);
driver_clutch_od = driver_clutch_id + 2*cage_clutch_size +2*driver_clutch_wall;

//height of the join between shaft and clutch
driver_join_h = 10;

/* [Guide] */

//offset to the outer diameter of the capsule
guide_d_offset = 3;

//inner diameter of the guide ring
guide_id = cap_od + guide_d_offset;

//height of the guide ring
guide_h = 15;

//thickness of the guide ring wall
guide_wall = 2;

//thickness of the guide bottom
guide_bottom = 5;

//outer diameter of the guide ring
guide_od = guide_id + 2*guide_wall;

//width of the guide base
guide_base_w = guide_od*2;

//distance of the guide base from center
guide_dist = 32;

//diameter of the guide holes
guide_hole_d = 4;

//upper diameter of the guide holes
guide_hole_ud = guide_hole_d*2+4;

/* [Inject Block] */

//outer diameter of the inject block
inject_od = guide_od;

//height of the inject block
inject_h = 35;

//diameter of the injector nut
inject_nut_d = 17.5;

//height of the injector nut
inject_nut_h = 8;


//diameter of the inject bore
inject_bore_d =10;

//diameter of the inject pin holder
inject_pinholder_d = inject_bore_d-4;

//diameter of the inject pin
inject_pin_d=3.2;

//height of the inject pin holder
inject_pinholder_h = 8;

//z height of the inject pin holder
inject_pinholder_z = 16;

//thickness of the internal inject pin holder connection
inject_pinholder_wall = 2;

//size difference of the pinholder slot
inject_pinholder_fit = 2;

/* [Hose connector] */

//max outer diameter of the stepped hose connector
hc_od1 = 8;

//min outer diameter of the hose conector
hc_od2 = 6;

//hose connector inner diameter/bore
hc_id = 4;

//hose connector segment height
hc_seg_h = hc_od2;

hc_join_h = 5;

//hose connector segments
hc_segments = 2;

//hose connector foot height
hc_foot_h = 8;

//hose connector foot fit offset
hc_foot_fit = 0.5;

//hose connector foot outer diameter
hc_foot_od = 12;

//hose connector total height
hc_h = hc_seg_h*hc_segments+hc_foot_h+hc_join_h;

/* [gearbox] */
gearbox_z = 26.5;
gearbox_x = 46;
gearbox_y = 32;
gearbox_shaft_x=15;

/* [motor block] */
mb_wall = 2;
mb_h = gearbox_z+2*mb_wall;
mb_w = gearbox_x;
mb_d = gearbox_y;
mb_slide_d=10;

module capsule_cage(){
    difference(){
        //body
        union(){
            cylinder(d=cage_od, h=cage_h);
            translate([0,0,cage_clutch_h-3]) cylinder(d1=cage_od, d2=cage_od+cage_clutch_size+2, h=3);
            translate([0,0,cage_clutch_h]) cylinder(d=cage_od+cage_clutch_size+2, h=cage_screw_h);
            
            
            //clutch
            for (a=[0:120:360]){
                rotate([0,0,a]) 
                translate([cage_id/2+cage_clutch_size/2,0,cage_clutch_h/2]) 
                cube([cage_clutch_size,cage_clutch_size,cage_clutch_h],center=true);
            }
        }
        //inner hole
        translate([0,0,cage_wall]) cylinder(d=cage_id, h=2*cage_h+2*eps);
        
        //screw holes
        for (a=[0:120:360]){
        rotate([0,0,a]) translate([cage_id/2,0,cage_hole_z]) rotate([0,90,0]) cylinder(d=cage_hole_d,h=cage_id,center=true, $fn=32);
        }
    }
    
    
}    

module shaft(h,d,flatness=0){
    difference(){
        cylinder(d=d,h=h);
        translate([-d/2,d/2-flatness,-eps]) cube([d,d,h+eps*2]);
    }
}

module cage_driver(){
    //shaft
    difference(){
        cylinder(d=driver_shaft_od, h=driver_shaft_h);
        translate([0,0,-eps]) shaft(d=driver_shaft_id,h=driver_shaft_h+2*eps,flatness=driver_shaft_flatness);
        for(dz=[0.25,0.75]) translate([0,0,dz*driver_shaft_h]) rotate([-90,0,0]) cylinder(d=driver_shaft_hole_d,h=driver_shaft_od/2);
    }
    
    //join
    translate([0,0,driver_shaft_h]) cylinder(d1=driver_shaft_od, d2=driver_clutch_od,h=driver_join_h);
    //clutch
    translate([0,0, driver_shaft_h+driver_join_h]) difference(){
        cylinder(d=driver_clutch_od, h=driver_clutch_h);
        translate([0,0,-eps]) cylinder(d=driver_clutch_id, h=driver_clutch_h+2*eps);
        
        for (a=[0:120:360]){
            rotate([0,0,a]) translate([cage_id/2+cage_clutch_size/2,-eps,driver_clutch_h/2]) cube([cage_clutch_size+driver_clutch_fit,cage_clutch_size+driver_clutch_fit,driver_clutch_h+eps],center=true);
        }
    }
}

module guide(h=guide_h, four_holes=false){
    iz_array = four_holes?[-1,1]:[0];
    difference(){
        
        //body
        hull(){
            cylinder(d=guide_od,h=h);
            translate([0,-guide_wall/2+guide_dist,h/2]) cube([guide_base_w, guide_wall, h], center=true);
        }
        
        //capsule hole    
        translate([0,0,-eps]) cylinder(d=guide_id,h=h+2*eps);
        
        //screw holes
        for (ix =[-1,+1], iz=iz_array) {
            
            //small
            translate([(guide_base_w/2-guide_hole_ud/2)*ix,0,h/2+iz*(h/2-(guide_hole_ud/2+2))]) rotate([-90,0,0]) cylinder(d=guide_hole_d, h=guide_dist+eps);
            
            //big
            //translate([(guide_base_w/2-guide_hole_ud/2)*ix,-guide_bottom,h/2+iz*(h/2-guide_hole_ud)]) rotate([-90,0,0]) cylinder(d=guide_hole_ud, h=guide_dist);
        }
        
        //bottom cutout
        translate([0,guide_dist,-eps]) cylinder(d=guide_base_w/2,h=h+2*eps);
        
        
        //TODO: cleanup, combine with small holes code above
        //side
        for (ix=[-1,1])
            translate([(guide_base_w/2-guide_hole_ud/2)*ix,-guide_bottom,h/2])
            hull() for (iz=iz_array)  {
                translate([0,0,iz*(h/2-(guide_hole_ud/2+2))]) rotate([-90,0,0]) cylinder(d=guide_hole_ud, h=guide_dist);
            
        
        }
        }
}

module inject_pinholder(fit=0,h=inject_pinholder_h){
    difference(){
        union(){
            cylinder(d=inject_pinholder_d, h=h);
            for (a=[0:90:360]) 
                rotate([0,0,a]) 
                translate([inject_bore_d/2,0,h/2]) 
                cube([inject_bore_d/2-0.85+fit/2, inject_pinholder_wall+fit,h], center=true);
        }
        translate([0,0,-eps]) cylinder(d=inject_pin_d, h=h+2*eps);
    }
}

module inject(){
    difference(){
        cylinder(d=inject_od, h=inject_h);
        translate([0,0,-eps]) cylinder(d=inject_nut_d, h=inject_nut_h, $fn=6);
        cylinder(d=inject_bore_d, h=inject_h+eps);
        translate([0,0,-eps]) inject_pinholder(fit=inject_pinholder_fit,h=inject_pinholder_z+inject_pinholder_h);
        //cube(100); //cutaway
        
        //translate([0,0,inject_h-hc_foot_h+eps]) cylinder(d=hc_foot_od+hc_foot_fit, h=hc_foot_h);
        translate([0,0,inject_h-hc_foot_h+eps]) metric_thread(12,3,hc_foot_h, thread_size=3, angle=35,taper=-0.0,leadin=0, internal=true);
        }
    
    
    guide(h=inject_h, four_holes=true);
}

module hose_connector(){
    difference(){
        union(){
            //segments
            translate([0,0,hc_foot_h+hc_join_h]) for (i=[0:hc_segments-1])
                translate([0,0,i*hc_seg_h]) cylinder(d1=hc_od1, d2=hc_od2, h=hc_seg_h);
            
            //foot
            //cylinder(d=hc_foot_od,h=hc_foot_h);
            metric_thread(12,3,hc_foot_h, thread_size=3, angle=35,taper=-0.0,leadin=3);
            
            //join
            translate([0,0,hc_foot_h]) cylinder(d1=hc_foot_od, d2=hc_od2, h=hc_join_h);
        }
        
        //bore
        translate([0,0,-eps]) cylinder(d=hc_id,h=hc_h+2*eps);
    }
}


module motor_block(){
    shaft_offset_x = -gearbox_x/2+gearbox_shaft_x;
    translate([shaft_offset_x,0,0]) union(){
        difference(){
            cube([mb_w,mb_d,mb_h],center=true);
            cube([gearbox_x+eps,gearbox_y+eps,gearbox_z],center=true);
            
            //shaft hole
            translate([-shaft_offset_x,0,mb_h/2-mb_wall-eps]) 
            hull()
                for (i=[0,-1]) translate([0,i*gearbox_y,0]) 
                    cylinder(d=driver_shaft_id+5,h=mb_wall+2*eps);
            
            //screw holes
            for (iy=[-1,1], x=[17.5, -17]) translate([x,iy*9,mb_h/2-mb_wall-eps])
                 cylinder(d=4.6,h=mb_wall+2*eps);
         
        }
        translate([0,mb_d/2+mb_wall/2,0]) cube([mb_w,mb_wall,mb_h], center=true);
        translate([mb_w/2+mb_wall/2,0,0]) cube([mb_wall,mb_d,mb_h], center=true);
    }
    
    //sliding plate
    //TODO: make clean code for dovetail match
    difference(){
        union(){
            translate([0,gearbox_y/2+mb_slide_d/2,-mb_h/2]) difference(){
                cube([guide_base_w+4,mb_slide_d,mb_h*2], center=true);
                for (ix = [-1,1]) translate([ix*15,0,0]) hull(){
                    cube([21,eps,mb_h*2+eps],center=true);
                    translate([0, mb_slide_d/2,0]) cube([11,eps,mb_h*2+eps], center=true);
                }
            }
            for(ix=[-1,+1])
                translate([ix*15,20,-mb_h]) rotate ([90,0,0]) cylinder(d=10, h=6, center=false);
        }
        
        for(ix=[-1,+1])
            translate([ix*15,20,-mb_h]) rotate ([90,0,0]) cylinder(d=2.5, h=50, center=true);
    }
    reenforcement();
    
    //print support();
}

module reenforcement(){
    translate([0,0,-mb_h])
    difference(){
        cube([5,gearbox_y, mb_h],center=true);
        translate([0,-35,-35]) rotate([-45,0,0]) cube([6,100, 100], center=true);
    }
}

module motor_plate(){
    //TODO: make clean code for dovetail match
    plate_h = guide_dist-mb_d/2- mb_slide_d-0.5;
    difference(){
        translate([0,guide_dist-plate_h/2,-mb_h/2]) 
        union() {
            cube([guide_base_w,plate_h,mb_h*2], center=true);
            for (ix = [-1,1]) translate([ix*15,-plate_h/2,0]) hull(){
                        cube([8,eps,mb_h*2+eps],center=true);
                        translate([0, -mb_slide_d/2,0]) cube([18,eps,mb_h*2+eps], center=true);
                    }
        }
        
        //drill holes
        for (ix=[-1,1], iz=[-1,1]) translate([ix*15,guide_dist+eps,-mb_h/2+ iz*15]) rotate([90,0,0]) {
            cylinder(d=4,h=plate_h+mb_slide_d/2+2*eps);
            translate([0,0,plate_h+mb_slide_d/2+2*eps-4]) cylinder(d1=4,d2=10,h=4);
        }
    }
}
module baseplate(){
    color("green") translate([0,2/2 + guide_dist,100])cube([100,2,300],center=true);
}



translate([0,0,210]) hose_connector();
//translate([0,0,150]) difference(){ inject(); cube(0);}
//translate([0,0,150]) inject_pinholder();
//translate([0,0,130]) guide();
//translate([0,0,80]) capsule_cage();
//translate([0,0,20]) cage_driver();
//motor_block();
//motor_plate();

//baseplate();