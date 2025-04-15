ActiveAdmin.register Page do
  # Permit the title and content for editing
  permit_params :title, :content

  index do
    selectable_column
    id_column
    column :title
    actions
  end

  # Show page for ActiveAdmin
  show do
    attributes_table do
      row :title
      row :content do |page|
        page.content.html_safe
      end
    end
  end

  # Form for editing in ActiveAdmin
  form do |f|
    f.inputs do
      f.input :title, hint: "For example: About, or Contact."
      f.input :content, as: :text, input_html: { rows: 10 }
    end
    f.actions
  end
end
