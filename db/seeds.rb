

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
end

puts "Members done, moving on to recovering donations..."

donations = DonationMigration.run()

donations.each do |donation|
	donation.delete("post_id")
	Donation.create(donation)
end

# linking members to url images and adding relivent tags
Member.find(21).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/SL-profile-pic-1_boe8ck.jpg")
Member.find(20).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/guitar-445387_1920_ppu9nz.jpg")
Member.find(20).update_column(:tags, "Music")
Member.find(19).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/BP-Pic_rzrhay.jpg")
Member.find(19).update_column(:tags, "Music")
Member.find(18).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/Filip-Photo_vgleq3.jpg")
Member.find(18).update_column(:tags, "Health,Empolyment")
Member.find(17).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/20170530_140242_resized-1_xpw1jd.jpg")
Member.find(17).update_column(:tags, "Home-Care,Housing")
Member.find(16).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/book_vjdhwv.jpg")
Member.find(16).update_column(:tags, "Education,Empolyment")
Member.find(15).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/20170428_100657_medysq.jpg")
Member.find(15).update_column(:tags, "Education,Empolyment")
Member.find(14).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/20170426_162515_qhqfdc.jpg")
Member.find(14).update_column(:tags, "Empolyment")
Member.find(13).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/fullsizeoutput_ed8_tnwexk.jpg")
Member.find(13).update_column(:tags, "Education")
Member.find(12).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/fullsizeoutput_ed3-380x295_vqtdym.jpg")
Member.find(12).update_column(:tags, "Family")
Member.find(11).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/titu_e5dax5.jpg")
Member.find(10).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/Untitled-collage_adzwqn.jpg")
Member.find(9).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/IMG_1665_uuz1rn.jpg")
Member.find(9).update_column(:tags, "Housing")
Member.find(8).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/john_jiiqjt.jpg")
Member.find(8).update_column(:tags, "Social")
Member.find(7).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/Mandy_rn3dm7.jpg")
Member.find(7).update_column(:tags, "Furniture,Housing")
Member.find(6).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/Mark_dcqcjm.jpg")
Member.find(6).update_column(:tags, "Education")
Member.find(5).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/Thomas-Photo_uo5uxg.jpg")
Member.find(5).update_column(:tags, "Family")
Member.find(4).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/Danny_ds8mzi.jpg")
Member.find(4).update_column(:tags, "Art-Supplies,Education")
Member.find(3).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/tara_m8pyom.jpg")
Member.find(3).update_column(:tags, "Family")
Member.find(2).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/Dariuz-Koziolek-Image_htzhff.jpg")
Member.find(2).update_column(:tags, "Empolyment")
#                                         https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/Edward-Ewa-square_ntsaqd.png
Member.find(1).update_column(:url_image, "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/Edward-Ewa-square_ntsaqd.png")
Member.find(1).update_column(:tags, "Education")

john_lewis = Sponsor.create({name: "John Lewis", sponsor_url_image: "https://s3-eu-west-1.amazonaws.com/givingweb-storage/images/john-lewis_sin7gw.png"})
Sponsorship.create({member_id: 6, sponsor_id: 1})

puts "Setting up Featured Members"
FeaturedMember.create({member_id: 20, position: 1})
FeaturedMember.create({member_id: 17, position: 2})
FeaturedMember.create({member_id: 16, position: 3})


puts "was successfully! Rails is ready, winner"
