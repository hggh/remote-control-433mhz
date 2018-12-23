$fn = 80;

module button() {
    cylinder(r=3.75, h=2, center=true);
}


module top() {
    difference() {
        cube([95, 40, 2]);
        
        // row 1
        translate([12, 10, -1]) {
            cylinder(r=6, h=4);
        }
        translate([12, 30, -1]) {
            cylinder(r=6, h=4);
        }
        
        // row 2
        translate([28, 10, -1]) {
            cylinder(r=6, h=4);
        }
        translate([28, 30, -1]) {
            cylinder(r=6, h=4);
        }
        
        // row 3
        translate([44, 10, -1]) {
            cylinder(r=6, h=4);
        }
        translate([44, 30, -1]) {
            cylinder(r=6, h=4);
        }
    }
}

union() {
    translate([0, 0, 19]) {
        top();
    }
    translate([20, 20, 13]) {
        cylinder(r=1, h=6);
    }
    translate([20, 37, 9]) {
        cube([1, 2, 2]);
    }
    translate([20, 2, 13]) {
        cylinder(r=1, h=6);
    }
    translate([20, 1, 9]) {
        cube([1, 2, 2]);
    }
    
    translate([20, 38, 13]) {
        cylinder(r=1, h=6);
    }
    
    translate([40, 20, 13]) {
        cylinder(r=1, h=6);
    }
    translate([40, 2, 13]) {
        cylinder(r=1, h=6);
    }
    translate([40, 38, 13]) {
        cylinder(r=1, h=6);
    }

    cube([1, 40, 19]);
    
    cube([95, 1, 19]); 
    
    translate([0, 39, 0]) {
        cube([95, 1, 19]); 
    }
    
    translate([94, 0, 0]) {
        cube([1, 40, 19]);
    }
}