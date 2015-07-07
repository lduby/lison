# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
r1 = Role.create({name: "Member", description: "Can read items"})
r2 = Role.create({name: "Team", description: "Can read and create items. Can update and destroy own items"})
r3 = Role.create({name: "Admin", description: "Can perform any CRUD operation on any resource"})

u1 = User.create(email: "sarah@example.com", password: "pass4sarah", password_confirmation: "pass4sarah", confirmed_at: Time.now, roles: Role.where(name: 'Regular'))
u2 = User.create(email: "julia@example.com", password: "pass4julia", password_confirmation: "pass4julia", confirmed_at: Time.now, roles: Role.where(name: 'Premium'))
u3 = User.create(email: "krosby@example.com", password: "pass4krosby", password_confirmation: "pass4krosby", confirmed_at: Time.now, roles: Role.where(name: 'Premium'))
u4 = User.create(email: "adam@example.com", password: "pass4adam", password_confirmation: "pass4adam", confirmed_at: Time.now, roles: Role.where(name: 'Admin'))
