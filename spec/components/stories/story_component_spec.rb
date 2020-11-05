require "rails_helper"

describe Stories::StoryComponent, type: "component" do
  let(:default_front_matter) do
    {
      title: "Swapping senior management for students",
      image: "/assets/images/stories/stories-karen.jpg",
      backlink: "./",
      backlink_text: "Career changers' stories",
      story: {
        teacher: "Karen Roberts",
        video: "https://www.youtube.com/embed/riY-1DUkLVk",
        position: "languages teacher",
      },
      more_stories: [
        {
          name: "Zainab",
          snippet: "School experience helped me decide to switch",
          image: "/assets/images/stories/stories-zainab.jpg",
          link: "/life-as-a-teacher/my-story-into-teaching/career-changers/school-experience-helped-me-decide-to-switch",
        },
        {
          name: "Katie",
          snippet: "Returning to teach with international experience",
          image: "/assets/images/stories/stories-katie.png",
          link: "/life-as-a-teacher/my-story-into-teaching/international-career-changers/returning-to-teaching-with-international-experience",
        },
        {
          name: "Helen",
          snippet: "Lawyer to assistant headteacher",
          image: "/assets/images/stories/stories-helen.jpg",
          link: "/life-as-a-teacher/my-story-into-teaching/career-progression/lawyer-to-assistant-teacher",
        },
      ],
      build_layout_from_frontmatter: true,
    }.with_indifferent_access
  end

  let(:front_matter) { default_front_matter }
  subject! { render_inline(Stories::StoryComponent.new(front_matter)) }

  describe "metadata content" do
    specify "renders a story" do
      expect(page).to have_css("article.story")
    end

    specify "the story's title forms the main heading" do
      expect(page).to have_css("h1", text: front_matter[:title])
    end

    specify "the story's image is rendered" do
      expect(page).to have_css(%(img[src='#{front_matter[:image]}']))
    end

    specify "the teacher name and position are in secondary heading" do
      [front_matter.dig(:story, :teacher), front_matter.dig(:story, :position)].each do |part|
        expect(page).to have_css("h2", text: Regexp.new(part))
      end
    end

    specify "the backlink is present" do
      expect(page).to have_link(front_matter[:backlink_text], href: front_matter[:backlink], class: %w[backlink backlink--top])
    end
  end

  describe "video" do
    let(:video_url) { "https://www.youtube.com/embed/riY-1DUkLVk" }
    let(:video_story) do
      { story: { teacher: "Karen Roberts", video: video_url, position: "languages teacher" } }
    end

    let(:front_matter) { default_front_matter.merge(video_story) }

    specify "the video iframe is present in the document and the src is correct" do
      expect(page).to have_css("iframe[src='#{video_url}']")
    end
  end

  describe "more information" do
    let(:text) { "Really interesting stuff" }
    let(:link) { "/really-interesting-stuff" }
    let(:more_information) { { more_information: { link: link, text: text } } }
    let(:front_matter) { default_front_matter.merge(more_information) }

    specify "the link is present in the document" do
      expect(page).to have_link(text, href: link)
    end
  end

  describe "content" do
    let(:content) { "The quick brown fox" }
    subject! do
      render_inline(Stories::StoryComponent.new(front_matter)) do
        content
      end
    end

    specify "the content is rendered" do
      expect(page).to have_content(content)
    end
  end

  describe "more stories" do
    context "when there are more stories" do
      specify "there is a more stories header" do
        expect(page).to have_css("h2", text: "More stories")
      end

      specify "there should be a story card for each story" do
        expect(page).to have_css(".story-cards.more-stories > .story-card", count: front_matter[:more_stories].length)
      end
    end

    context "when there are no more stories" do
      let(:front_matter) { default_front_matter.merge(more_stories: nil) }

      specify "there is no more stories header" do
        expect(page).not_to have_css("h2", text: "More stories")
      end
    end
  end
end