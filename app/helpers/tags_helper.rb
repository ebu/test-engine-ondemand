module TagsHelper
  def tags_for(tags)
    [].tap do |arr|
      tags.each do |t|
        arr << content_tag(:span, t, class: 'badge')
      end
    end.join(' ').html_safe
  end
  
  def checkboxes_for_tags(form, object, collection)
    form.collection_check_boxes(object, collection, :name, :name) do |b|
      '<div class="checkbox">'.html_safe +
      b.label { b.check_box + b.text } +
      '</div>'.html_safe
    end
  end
  
  def combined_tags_for_encoding_job(job)
    all_tags = job.combined_tags
  end
end
