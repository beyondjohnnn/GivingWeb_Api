

User.delete_all

puts "Creating template Users and charities..."

User.create(
	first_name: 'Eoghan',
	last_name: 'Crowley',
	email: 'eoghanscrowley@gmail.com',
	password: 'abcdef',
	password_confirmation: 'abcdef'
)
User.create(
	first_name: 'Reece',
	last_name: 'Jones',
	email: 'reece.c.jones@gmail.com',
	password: '123456',
	password_confirmation: '123456'
)
User.create(
	first_name: 'Johnny',
	last_name: 'Watson',
	email: 'johnny@streetchange.org.uk',
	password: 'abcdef',
	password_confirmation: 'abcdef'
)

Charity.delete_all

Charity.create(
	name: 'Streetwork',
	description: 'For the last 25 years, Streetwork has been supporting Edinburgh’s most vulnerable and disadvantaged communities, with a particular emphasis on those with multiple complex needs who have experienced, or are at risk of homelessness. They recognise that people who have faced adversity throughout their lives often find it hard to build and maintain healthy relationships, resulting in their exclusion from relationships with people and services. This isolation frequently results in long term substance use, mental ill health and job instability. Streetwork therefore delivers, and continues to develop, relationship-focused services that aim to work in partnership with individuals in need — basing their efforts on respect and trust. Streetwork helps people find their own solution, with a ‘your terms, your pace, your place’ mindset.\n\nIn addition, to building based services, free phone line support, group work and individual support sessions, Streetwork also takes its services to the streets with daily, walking community outreach. In this way, Streetwork is committed to supporting people in making sustainable, positive, informed decisions to help them achieve a life off the streets.',
	email: 'streetwork@streetwork.com',
	password: 'abcdef',
	password_confirmation: 'abcdef'
)

puts "Cleaning up database(just in case) please wait..."

FeaturedMember.delete_all
Member.delete_all
Donation.delete_all
Legacy.delete_all
Comment.delete_all

puts "Connecting to Legacy database..."

members = MemberMigration.build_member_hashes
comments = CommentMigration.run()

puts "Recovering Legacy Mysql data, this my take a few secs..."
members.each do |member|
	member[:member_data].delete('title')
	member[:member_data].delete('meta_description')
	dbMember = Member.create(member[:member_data])
	Legacy.create({member_id: dbMember.id, legacy_sql_id: member[:legacy_sql_id]})

	related_comments = comments.select do |comment|
		comment['comment_post_ID'] == member[:legacy_sql_id]
	end

	related_comments.each do |comment|
		comment.delete('comment_post_ID')
		comment.delete('comment_ID')
		comment['member_id'] = dbMember.id
		Comment.create(comment)
	end
	# pp related_comments
end

puts "Members done, moving on to recovering donations..."

donations = DonationMigration.run()

donations.each do |donation|
	donation.delete("post_id")
	Donation.create(donation)
end

puts "was successfully! Rails is ready, winner
"
