$fn = 80;

module button() {
    cylinder(r=3.75, h=2, center=true);
}


module top() {
    difference() {
        cube([106, 40, 2]);
        
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

module pcb_holder() {
    cylinder(r=1, h=6);
}

union() {
    translate([0, 0, 19]) {
        top();
    }
    translate([20, 2, 9]) {
        pcb_holder();
    }
    
    translate([20, 38, 9]) {
       pcb_holder();
    }
    
    translate([40, 2, 9]) {
        pcb_holder();
    }
    translate([40, 38, 9]) {
        pcb_holder();
    }

    cube([2, 40, 19]);
    
    translate([0, -1, 0]) {
        cube([106, 2, 21]); 
    }
    
    translate([0, 39, 0]) {
        cube([106, 2, 21]); 
    }
    
    translate([104, 0, 0]) {
        cube([2, 40, 19]);
    }
}