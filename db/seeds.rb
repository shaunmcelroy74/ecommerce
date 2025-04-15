# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Page.find_or_create_by!(title: 'About') do |page|
  page.content = "This is our about page. Write something inspiring about your brand."
end

Page.find_or_create_by!(title: 'Contact') do |page|
  page.content = "This is our contact page. Provide your contact details or a contact form here."
end
