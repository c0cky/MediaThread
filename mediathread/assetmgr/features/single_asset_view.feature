Feature: Single Asset View    
    
    Scenario: single_asset_view.feature 1. Basic Item View
        Using selenium
        Given I am test_instructor in Sample Course
        
        When I access the url "/asset/2/"
        Given the asset workspace is loaded
        
        Then there is a minimized Collection panel        
        And there is an open Asset panel

        # Verify the asset is really there
        The item header is "MAAP Award Reception"
        There is an "Item" link
        There is a "Source" link
        There is a "References" link        
        And there is not an Edit this item button
        And there is a View button
        And there is a Create button
        
        # Verify the Quick Help popup is visible
        Contextual help is visible for the asset
        When I close the asset's contextual help
        Contextual help is not visible for the asset
        
        # Verify the Sources tab
        When I click the "Source" link
        And there is an "Item Permalink" link
                        
        Finished using Selenium
        
    Scenario: single_asset_view.feature 2. Edit global annotation
        Using selenium
        Given I am test_instructor in Sample Course
        
        When I access the url "/asset/2/"
        Given the asset workspace is loaded
        Then there is a minimized Collection panel        
        And there is an open Asset panel
        And the asset workspace is loaded
        
        # Verify the Quick Help popup is visible
        Contextual help is visible for the asset
        When I close the asset's contextual help
        Contextual help is not visible for the asset
        
        # Verify the asset is really there
        The item header is "MAAP Award Reception"
        And I see "instructor one item note"
        And I see "flickr, instructor_one"
        And I do not see "Here are my notes"
        And I do not see "abc"
        When I edit the item
        Then there is a Cancel button
        And there is a Save button
        
        When I set the "Title" "text" field to "Updated MAAP Award Reception"
        And I remove the existing select2 tags at ".global-annotation-tags.select2-container"
        And I set the field with selector ".global-annotation-tags.select2-container input.select2-input" to "abc"
        And I set the "Notes" "textarea" field to "Here are my notes"
        And I click the Save button
        
        Then the item header is "Updated MAAP Award Reception"
        And I see "Here are my notes"
        And I see "abc"
        And I do not see "instructor one item note"
        And I do not see "flickr, instructor_one"
                        
        Finished using Selenium
        
    Scenario: single_asset_view.feature 3. Edit global annotation as student
        Using selenium
        Given I am test_student_one in Sample Course
        
        When I access the url "/asset/2/"
        Given the asset workspace is loaded
        Then there is a minimized Collection panel        
        And there is an open Asset panel
        And the asset workspace is loaded
        
        # Verify the Quick Help popup is visible
        Contextual help is visible for the asset
        When I close the asset's contextual help
        Contextual help is not visible for the asset
        
        # Verify the asset is really there
        The item header is "MAAP Award Reception"
        And I see "student one item note"
        And I see "student_one_item"
        And I do not see "Here are my notes"
        And I do not see "abc"
        
        When I edit the item
        Then there is a Cancel button
        And there is a Save button
        And there is not a "Title" "text" field
        
        And I remove the existing select2 tags at ".global-annotation-tags.select2-container"
        And I set the field with selector ".global-annotation-tags.select2-container input.select2-input" to "abc"
        And I set the "Notes" "textarea" field to "Here are my notes"
        And I click the Save button
        
        Then the item header is "MAAP Award Reception"
        And I see "Here are my notes"
        And I see "abc"
        And I do not see "student one item note" in the item tab
        Then I wait 1 second
        And I do not see "student_one_item"
                        
        Finished using Selenium
        
        
    Scenario: single_asset_view.feature 4. References tab
        Using selenium
        Given I am test_student_one in Sample Course
        Given there are no projects
        
        # Create a project from the home page
        Given the home workspace is loaded
        There is a Create button
        When I click the Create button
        There is a Create Composition button
            
        When I click the Create Composition button        
        
        Given the composition workspace is loaded
        Then I am at the Untitled page
        Then I see "by Student One"
        And I see "Draft"
        
        # Add a title and some text and an asset
        Then I call the Composition "Single Asset View 4"
        And I write some text for the Composition
        And I insert "MAAP Award Reception" into the text

        # Save
        When I click the Save button
        Then I set the project visibility to "Whole Class - all class members can view"
        Then I save the changes
        And there is a "Published to Class" link

        # Navigate to the asset
        When I access the url "/asset/2/"
        Given the asset workspace is loaded
        Then there is a minimized Collection panel        
        And there is an open Asset panel
        
        # Verify the Quick Help popup is visible
        Contextual help is visible for the asset
        When I close the asset's contextual help
        Contextual help is not visible for the asset
        
        # Check the references tab
        Then I click the "References" link
        And I see "Tags"
        And there is a "flickr (1)" link
        And there is an "image (1)" link
        And there is an "instructor_one (1)" link
        And there is an "instructor_one_selection (1)" link
        And there is a "student_one_item (1)" link
        And there is a "student_one_selection (1)" link
        And there is a "student_two_item (1)" link
        And there is a "student_two_selection (1)" link
        And I see "Class References"
        And there is a "Single Asset View 4" link

        Finished using Selenium
