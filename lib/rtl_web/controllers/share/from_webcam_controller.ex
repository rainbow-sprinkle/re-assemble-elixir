defmodule RTLWeb.Share.FromWebcamController do
  use RTLWeb, :controller
  alias RTL.Helpers, as: H
  alias RTL.Videos

  plug :load_project
  plug :load_prompt

  # For now, we don't require a logged-in user nor any sort of voucher code.
  # Anyone can record and upload an interview as many times as they want.
  def new(conn, _params) do
    changeset = Videos.new_video_changeset(%{})
    uuid = H.random_hex()
    thumbnail_filename = "#{uuid}.jpg"
    recording_filename = "#{uuid}.webm"

    render(conn, "new.html",
      changeset: changeset,
      thumbnail_filename: thumbnail_filename,
      recording_filename: recording_filename,
      thumbnail_presigned_s3_url: presigned_url("uploads/thumbnail/#{thumbnail_filename}"),
      recording_presigned_s3_url: presigned_url("uploads/recording/#{recording_filename}")
    )
  end

  def create(conn, %{"video" => video_params}) do
    # For now, assume that there's no risk of validation errors
    Videos.insert_video!(populate_title(video_params))

    conn
    |> put_flash(:info, submission_confirmation_message())
    |> redirect(to: Routes.collect_from_webcam_path(conn, :thank_you))
  end

  def thank_you(conn, _params) do
    render(conn, "thank_you.html")
  end

  #
  # Helpers
  #

  defp presigned_url(path) do
    # See https://stackoverflow.com/a/42211543/1729692
    bucket = System.get_env("S3_BUCKET")

    {:ok, url} =
      ExAws.S3.presigned_url(ExAws.Config.new(:s3), :put, bucket, path,
        query_params: [{"x-amz-acl", "public-read"}, {"contentType", "binary/octet-stream"}]
      )

    url
  end

  defp populate_title(params) do
    title =
      if H.is_present?(params["source_name"]) do
        "Interview with #{params["source_name"]}"
      else
        "Anonymous interview"
      end

    Map.merge(params, %{"title" => title})
  end

  defp submission_confirmation_message do
    "Thank you! We've received your interview and we're looking forward to learning from your experience."
  end
end