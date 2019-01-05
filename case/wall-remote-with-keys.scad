$fn=80;

module topbox() {
    difference() {
        cube([130,  35, 70]);
        translate([2, 2, 0]) {
            cube([126, 35, 68]);
        }
        translate([9.5, 0, 4.75]) {
            cube([55.5 * 2, 1.2, 60.5]);
        }
        translate([75, 0, 40/ 4]) {
            cube([40, 3, 50]);
        }
        translate([15, 0, 40/ 4]) {
            cube([40, 3, 50]);
        }
    }
}

module middlebox() {
    difference() {
        translate([0, -30, -55]) {
            cube([130, 65, 55]);
        }
        translate([2, -28, -55]) {
             cube([126, 63, 53]);
        }
        translate([2, 2, -2]) {
            cube([126, 35, 3]);
        }
        translate([0, -30, -55]) {
            translate([(130/4)*1, 0, 55/2]){
                rotate([0, 90, 90]) cylinder(r=20.5, h=100,  center=true);
            }
            translate([(130/4)*3, 0, 55/2]){
                rotate([0, 90, 90]) cylinder(r=20.5, h=100,  center=true);
            }
        }
    }
}


union() {
    topbox();
    middlebox();
}