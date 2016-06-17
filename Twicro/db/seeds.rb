# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# =========================================
#     2   3
#   1| | | |
#    | |*| |
#   4| | | |
#
Temp.create(height:1, width:1)

Black.create(temp_id:1, column:1, row:1)

White.create(temp_id:1, no:1, row:0, column:0, length:3, horizonal:true)
White.create(temp_id:1, no:2, row:0, column:0, length:3, horizonal:false)
White.create(temp_id:1, no:3, row:0, column:2, length:3, horizonal:false)
White.create(temp_id:1, no:4, row:2, column:0, length:3, horizonal:true)

Relation.create(temp_id:1, no1:1, index1:0, no2:2, index2:0)
Relation.create(temp_id:1, no1:1, index1:2, no2:3, index2:0)
Relation.create(temp_id:1, no1:2, index1:2, no2:4, index2:0)
Relation.create(temp_id:1, no1:3, index1:2, no2:4, index2:2)

# =========================================
