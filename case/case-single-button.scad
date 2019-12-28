CASE_SIZE_Y = 45;
CASE_SIZE_X = 45;
CASE_SIZE_Z = 40;

BUTTON_SIZE = 19;


difference() {
    cube([CASE_SIZE_X, CASE_SIZE_X, CASE_SIZE_Z]);
    translate([2, 2, -1]) {
        cube([CASE_SIZE_X - 4, CASE_SIZE_X - 4, CASE_SIZE_Z -1]);
    }
    translate([CASE_SIZE_Y/2, CASE_SIZE_X/2, 0]) {
        cylinder(d=BUTTON_SIZE, h=50, $fn=80);
    }
}

translate([0, 50, 0]) {
    cube([CASE_SIZE_X - 4.2, 5, 1.2]);
}