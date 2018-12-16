$fn = 80;

module button() {
    cylinder(r=3.75, h=2, center=true);
}


module top() {
    difference() {
        cube([80, 35, 1]);
        
        // row 1
        translate([10, 8.75, 0]) {
            cylinder(r=3.75, h=2);
        }
        translate([10, 26.25, 0]) {
            cylinder(r=3.75, h=2);
        }
        
        // row 2
        translate([24, 8.75, 0]) {
            cylinder(r=3.75, h=2);
        }
        translate([24, 26.25, 0]) {
            cylinder(r=3.75, h=2);
        }
        
        // row 3
        translate([38, 8.75, 0]) {
            cylinder(r=3.75, h=2);
        }
        translate([38, 26.25, 0]) {
            cylinder(r=3.75, h=2);
        }
    }
}

union() {
    translate([0, 0, 19]) {
        top();
    }
    cube([1, 35, 19]);
    
    cube([80, 1, 19]); 
    
    translate([0, 34, 0]) {
        cube([80, 1, 19]); 
    }
    
    translate([79, 0, 0]) {
        cube([1, 35, 19]);
    }
}