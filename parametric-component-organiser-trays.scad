// Parametric component/organiser trays
// https://github.com/bendetat/parametric-component-organiser-trays

// Usage:
// Call tray() with no parameters for a 200x150x25 tray with 12 cutouts.
// Use optional parameters to set the dimensions, number of cutout rows and columns, and to remove horizontal and vertical slots (and the pins left behind) to make larger cutouts and different designs.
// Combine trays for some crazyness.
// Parameters:
//      trayX           The width of the tray (default 200)
//      trayY           The depth of the tray (default 150)
//      trayZ           The height of the tray (default 25)
//      wallThickness   The thickness of the tray walls (default 1)
//      insertCountX    Number of rows
//      insertCountY    Number of columns
//      removedHSlots   Array of [row,col] pairs indicating the horizontal slots to remove
//      removedVSlots   Array of [row,col] pairs indicating the vertical slots to remove
//      removedPins     Array of [row,col] pairs indicating the pins to remove

// Examples:
tray();
//tray(100,100,20,3,3,1); // 100x100, 3x3, 1mm walls
//singleMediumCutout();
//largeAndMediumCutouts();

// combined tray
//tray();
//tray(insertCountX=3, insertCountY=2);

module singleMediumCutout()
tray(
    removedHSlots = [[0,1]]   
);
module largeAndMediumCutouts()
tray(
    removedHSlots = [[0,1],[1,1]],
    removedVSlots = [[1,0],[1,1],[1,2]],
    removedPins = [[1,1]]
);




// Model code

module tray(trayX = 200, trayY = 150, trayZ = 25,insertCountX = 4, insertCountY = 3, wallThickness = 1, removedHSlots = [], removedVSlots = [], removedPins = []) {
    insertX = (trayX - wallThickness*(insertCountX + 1)) / insertCountX;
    insertY = (trayY - wallThickness*(insertCountY + 1))/insertCountY;
    
    echo(insertX, insertY);

    translate([-trayX/2,-trayY/2,0])
    difference() {
        cube([trayX, trayY, trayZ]);
        cutouts(insertX, insertY, trayZ, insertCountX, insertCountY, wallThickness);
        hSlots(insertX, insertY, trayZ, wallThickness, removedHSlots);
        vSlots(insertX, insertY, trayZ, wallThickness, removedVSlots );
        pins(insertX, insertY, trayZ, wallThickness, removedPins);
    }
}

module cutouts(insertX, insertY, trayZ, insertCountX, insertCountY, wallThickness) {
    for (x = [0:insertCountX]) {
        for (y = [0:insertCountY]) {
            color("pink")
            translate([
                insertX*x + wallThickness*(x + 1),
                insertY*y + wallThickness*(y + 1),
                wallThickness + 0.01
            ])
            cube([
               insertX,
                insertY,
                trayZ - wallThickness + 0.01
            ]);
        }
    }
}

module hSlots(insertX, insertY, trayZ, wallThickness, removedHSlots) {
    if (len(removedHSlots) != 0) {
        for (i = [0:len(removedHSlots)-1]) {
            x = removedHSlots[i][0];
            y = removedHSlots[i][1];
            translate([
                (insertX*x) + wallThickness*(x + 1),
                (insertY*y) + wallThickness*(y) - 0.01,
                wallThickness + 0.01
            ])
            cube([
                insertX,
                wallThickness + 0.02,
                trayZ - wallThickness
            ]);
        }
    }
}

module vSlots(insertX, insertY, trayZ, wallThickness, removedVSlots) {
    if (len(removedVSlots) != 0) {
        for (i = [0:len(removedVSlots)-1]) {
            x = removedVSlots[i][0];
            y = removedVSlots[i][1];
            translate([
                (insertX*x) + wallThickness*x - 0.01,
                (insertY*y) + wallThickness*(y + 1),
                wallThickness + 0.01
            ])
            cube([
                wallThickness + 0.02,
                insertY,
                trayZ - wallThickness
            ]);
        }
    }
}

module pins(insertX, insertY, trayZ, wallThickness, removedPins) {
    if (len(removedPins) != 0) {
        for (i = [0:len(removedPins) - 1]) {
            x = removedPins[i][0];
            y = removedPins[i][1];
            translate([
                (insertX*x) + wallThickness*x - 0.01,
                (insertY*y) + wallThickness*y - 0.01,
                wallThickness + 0.01
            ])
            cube([
                wallThickness + 0.02,
                wallThickness + 0.02,
                trayZ - wallThickness + 0.01
            ]);
        }
    }
}