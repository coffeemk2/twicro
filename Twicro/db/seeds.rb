# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# =========================================
#     1   2
#   0| | | |
#    | |*| |
#   3| | | |
#
Temp.create(height:3, width:3)

Black.create(temp_id:1, column:1, row:1)

White.create(temp_id:1, no:0, row:0, column:0, length:3, horizonal:true)
White.create(temp_id:1, no:1, row:0, column:0, length:3, horizonal:false)
White.create(temp_id:1, no:2, row:0, column:2, length:3, horizonal:false)
White.create(temp_id:1, no:3, row:2, column:0, length:3, horizonal:true)

Relation.create(temp_id:1, no1:0, index1:0, no2:1, index2:0)
Relation.create(temp_id:1, no1:0, index1:2, no2:2, index2:0)
Relation.create(temp_id:1, no1:1, index1:2, no2:3, index2:0)
Relation.create(temp_id:1, no1:2, index1:2, no2:3, index2:2)
#
# =========================================

# =========================================
#     5 1 2 6
#   0| | | |*|
#   3|*| | | |
#   4| | |*| |
#   7| |*| | |
#
Temp.create(height:4, width:4)

Black.create(temp_id:2, column:0, row:1)
Black.create(temp_id:2, column:1, row:3)
Black.create(temp_id:2, column:2, row:2)
Black.create(temp_id:2, column:3, row:0)

White.create(temp_id:2, no:0, row:0, column:0, length:3, horizonal:true)
White.create(temp_id:2, no:1, row:0, column:1, length:3, horizonal:false)
White.create(temp_id:2, no:2, row:0, column:2, length:2, horizonal:false)
White.create(temp_id:2, no:3, row:1, column:1, length:3, horizonal:true)
White.create(temp_id:2, no:4, row:2, column:0, length:2, horizonal:true)
White.create(temp_id:2, no:5, row:2, column:0, length:2, horizonal:false)
White.create(temp_id:2, no:6, row:1, column:3, length:3, horizonal:false)
White.create(temp_id:2, no:7, row:3, column:2, length:2, horizonal:true)

Relation.create(temp_id:2, no1:0, index1:1, no2:1, index2:0)
Relation.create(temp_id:2, no1:0, index1:2, no2:2, index2:0)
Relation.create(temp_id:2, no1:1, index1:1, no2:3, index2:0)
Relation.create(temp_id:2, no1:1, index1:2, no2:4, index2:1)
Relation.create(temp_id:2, no1:2, index1:1, no2:3, index2:1)
Relation.create(temp_id:2, no1:3, index1:2, no2:6, index2:0)
Relation.create(temp_id:2, no1:4, index1:0, no2:5, index2:0)
Relation.create(temp_id:2, no1:6, index1:2, no2:7, index2:1)
#
# =========================================
