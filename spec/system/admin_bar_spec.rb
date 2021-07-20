# frozen_string_literal: true

require 'spec_helper'

describe 'Admin Bar', type: :system do
  describe 'home page' do
    context "when an admin user" do
      before do
        sign_in_as_admin!
        visit spree.root_path
      end

      it "displays the admin bar and links to dashboard" do
        within('#admin_bar'){ click_link 'Dashboard' }
        expect(page).to have_current_path(spree.admin_orders_path, ignore_query: true)
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

    context "when an admin user" do
      before do
        sign_in_as_admin!
        visit spree.root_path
        click_link 'Superman T-Shirt'
      end

      it "can navigate to edit the product in the admin" do
        within('#admin_bar'){ click_link 'Edit Product' }
        expect(page).to have_current_path(spree.edit_admin_product_path(product), ignore_query: true)
      end

      it "allows an admin user to edit product images in the admin" do
        within('#admin_bar'){ click_link 'Images' }
        expect(page).to have_current_path(spree.admin_product_images_path(product), ignore_query: true)
      end

      it "allows an admin user to edit variants in the admin" do
        within('#admin_bar'){ click_link 'Variants' }
        expect(page).to have_current_path(spree.admin_product_variants_path(product), ignore_query: true)
      end

      it "allows an admin user to edit prices in the admin" do
        within('#admin_bar'){ click_link 'Prices' }
        expect(page).to have_current_path(spree.admin_product_prices_path(product), ignore_query: true)
      end

      it "allows an admin user to edit properties in the admin" do
        within('#admin_bar'){ click_link 'Properties' }
        expect(page).to have_current_path(spree.admin_product_product_properties_path(product), ignore_query: true)
      end

      it "allows an admin user to edit stock in the admin" do
        within('#admin_bar'){ click_link 'Stock' }
        expect(page).to have_current_path(spree.admin_product_stock_path(product), ignore_query: true)
      end
    end

    it "does not allow a regular user to navigate to the admin" do
      sign_in_as_user!
      visit spree.root_path
      click_link 'Superman T-Shirt'
      expect(page).not_to have_content('Edit Product')
    end

    it "does not allow a guest user to navigate to the admin" do
      visit spree.root_path
      click_link 'Superman T-Shirt'
      expect(page).not_to have_content('Edit Product')
    end
  end

  describe 'taxons admin bar' do
    let!(:taxonomy) { create(:taxonomy, name: "Category") }
    let!(:taxon) { taxonomy.root.children.create(name: "Clothing", taxonomy_id: taxonomy.id) }

    context "when an admin user" do
      before do
        sign_in_as_admin!
        visit spree.root_path
        click_link 'Clothing'
      end

      it "can navigate to edit the taxonomy in the admin" do
        within('#admin_bar'){ click_link 'Edit Taxonomy' }
        expect(page).to have_current_path(spree.edit_admin_taxonomy_path(taxonomy), ignore_query: true)
      end

      it "can navigate to edit the taxon in the admin" do
        within('#admin_bar'){ click_link 'Edit Taxon' }
        expect(page).to have_current_path(spree.edit_admin_taxonomy_taxon_path(taxonomy.id, taxon.id),
          ignore_query: true)
      end
    end

    it "does not allow a normal user to navigate to the admin" do
      sign_in_as_user!
      visit spree.root_path
      click_link 'Clothing'
      expect(page).not_to have_content('Edit Taxonomy')
    end

    it "does not allow a guest user to navigate to the admin" do
      visit spree.root_path
      click_link 'Clothing'
      expect(page).not_to have_content('Edit Taxonomy')
    end
  end
end

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
