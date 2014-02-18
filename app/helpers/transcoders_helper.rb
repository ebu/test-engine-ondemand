module TranscodersHelper
  def transcoder_available_label(transcoder)
    if transcoder.available?
      content_tag :span, "Available", class: "label label-success"
    else
      content_tag :span, "Not Available", class: "label label-danger"
    end
  end
end
