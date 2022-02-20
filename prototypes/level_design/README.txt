Sydney Burgess's Level Design Prototype

Has the following functions currently:
-Basic floor plan generation
	-Generates general, boss and player spawn rooms. Player always spawns far away from boss.
	-Skeleton code for potential classes that could store room data, and data of items located inside of room.
-Prototype for possible room construction via ascii text.
	-Ascii text is stored in string array.
	-Due to being stored this way, allows for construction of room in mirrored and rotated manner.
-Basic testing for loading in scenes, intended for possible future loading and unloading of rooms.

Needs implementation/correction:
-Implement support for loading and unloading rooms.
	-Implement basic room "template" files.
	-Environmental objects such as walls, pits, etc.
