# frozen_string_literal: true

require 'spec_helper'

context 'admin bar home page' do
  context "an admin user" do
    before do
      sign_in_as_admin!
      visit spree.root_path
    end
    it "should display the admin bar and links to dashboard" do
      within('#admin_bar'){ click_link 'Dashboard' }
      expect(current_path).to eq(spree.admin_orders_path)
    end
  end

  it "does not allow a regular user to see the admin bar" do
    sign_in_as_user!
    visit spree.root_path
    expect(page).not_to have_content('Dashboard')
  end

  it "does not allow a guest user to see the admin bar" do
    visit spree.root_path
    expect(page).not_to have_content('Dashboard')
  end
end

describe 'products admin bar' do
  let!(:product) { create(:product, name: "Superman T-Shirt") }
  context "an admin user" do
    before do
      sign_in_as_admin!
      visit spree.root_path
      click_link 'Superman T-Shirt'
    end
    it "can navigate to edit the product in the admin" do
      within('#admin_bar'){ click_link 'Edit Product' }
      expect(page).to have_content(product.name)
      expect(current_path).to eq(spree.edit_admin_product_path(product))
    end
    it "allows an admin user to edit product images in the admin" do
      within('#admin_bar'){ click_link 'Images' }
      expect(current_path).to eq(spree.admin_product_images_path(product))
    end
    it "allows an admin user to edit variants in the admin" do
      within('#admin_bar'){ click_link 'Variants' }
      expect(current_path).to eq(spree.admin_product_variants_path(product))
    end
    it "allows an admin user to edit prices in the admin" do
      within('#admin_bar'){ click_link 'Prices' }
      expect(current_path).to eq(spree.admin_product_prices_path(product))
    end
    it "allows an admin user to edit properties in the admin" do
      within('#admin_bar'){ click_link 'Properties' }
      expect(current_path).to eq(spree.admin_product_product_properties_path(product))
    end
    it "allows an admin user to edit stock in the admin" do
      within('#admin_bar'){ click_link 'Stock' }
      expect(current_path).to eq(spree.admin_product_stock_path(product))
    end
    # it "allows an admin user to edit related products in the admin" do
    #   within('#admin_bar'){ click_link 'Related' }
    #   expect(current_path).to eq(spree.related_admin_product_path(product))
    # end
  end

  it "does not allow a regular user to navigate to the admin" do
    sign_in_as_user!
    visit spree.root_path
    click_link 'Superman T-Shirt'
    expect(page).not_to have_content('Dashboard')
    expect(page).to_not have_content('Edit Product')
  end

  it "does not allow a guest user to navigate to the admin" do
    visit spree.root_path
    click_link 'Superman T-Shirt'
    expect(page).not_to have_content('Dashboard')
    expect(page).to_not have_content('Edit Product')
  end
end

describe 'taxons admin bar' do
  let!(:taxonomy) { create(:taxonomy, name: "Category") }
  let!(:taxon) { taxonomy.root.children.create(name: "Clothing", taxonomy_id: taxonomy.id) }
  context "an admin user" do
    before do
      sign_in_as_admin!
      visit spree.root_path
      click_link 'Clothing'
    end
    it "can navigate to edit the taxonomy in the admin" do
      within('#admin_bar'){ click_link 'Edit Taxonomy' }
      expect(current_path).to eq(spree.edit_admin_taxonomy_path(taxonomy))
    end
    it "can navigate to edit the taxon in the admin" do
      within('#admin_bar'){ click_link 'Edit Taxon' }
      expect(current_path).to eq(spree.edit_admin_taxonomy_taxon_path(taxonomy.id, taxon.id))
    end
  end
  it "does not allow a normal user to navigate to the admin" do
    sign_in_as_user!
    visit spree.root_path
    click_link 'Clothing'
    expect(page).not_to have_content('Dashboard')
    expect(page).to_not have_content('Edit Taxonomy')
    expect(page).to_not have_content('Edit Taxon')
  end
  it "does not allow a guest user to navigate to the admin" do
    visit spree.root_path
    click_link 'Clothing'
    expect(page).not_to have_content('Dashboard')
    expect(page).to_not have_content('Edit Taxonomy')
    expect(page).to_not have_content('Edit Taxon')
  end
end

# describe 'pages admin bar' do
#   let!(:store) { create(:store, default: true) }
#   let!(:content_page) { Spree::Page.create!(slug: '/page2', title: 'TestPage2', body: 'Body2', visible: true, stores: [store]) }
#   it "an admin user can navigate to edit the page in the admin" do
#     sign_in_as_admin!
#     visit '/page2'
#     expect(page).to have_content('Edit Page')
#     within('#admin_bar'){ click_link 'Edit Page' }
#     current_path.expect == spree.edit_admin_page_path(content_page)
#   end
#   it "does not allow a regular user to navigate to the admin" do
#     visit '/page2'
#     page.expect_not have_content('Edit Page')
#   end
# end

def sign_in_as_admin!
  user = create(:admin_user)
  visit '/login'
  fill_in 'Email', with: user.email
  fill_in 'Password', with: 'secret'
  click_button 'Login'
end

def sign_in_as_user!
  user = create(:user)
  visit '/login'
  fill_in 'Email', with: user.email
  fill_in 'Password', with: 'secret'
  click_button 'Login'
end

def create_taxon
  taxonomy = create(:taxonomy, name: "Category")
  create(:taxon, name: "T-Shirts", parent: taxonomy.root, taxonomy: taxonomy)
end
