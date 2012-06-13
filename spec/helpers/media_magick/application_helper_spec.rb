require 'spec_helper'

describe MediaMagick do
  describe ApplicationHelper do
    describe 'attachmentUploader' do
      let(:album) { Album.new }

      before do
        album.stub(id: '12345678')
      end

      def conteiner_html(model, relation, data_attributes, &block)
        content_tag(:div, nil, id: "#{model}-#{relation}", class: "attachmentUploader #{relation}", data: data_attributes) do
          class_eval(&block) if block_given?
        end
      end

      context 'without block' do
        before do
          album.stub(id: '12345678')

          helper.stub(:render)
        end

        it 'should create a div with data attributes' do
          helper.attachment_container(album, :photos).should eq(conteiner_html('album', 'photos', { id: 12345678, model: 'Album', relation: 'photos', partial: '/image' }))
        end

        it 'should render /upload partial' do
          helper.should_receive(:render).with('/upload', model: album, relations: :photos, newAttachments: {}, loadedAttachments: {}, partial: '/image')

          helper.attachment_container(album, :photos)
        end

        context 'using partials' do
          it 'should create a div with data-partial attributes' do
            helper.attachment_container(album, :photos, partial: 'albums/photo').should eq(conteiner_html('album', 'photos', { id: 12345678, model: 'Album', relation: 'photos', partial: 'albums/photo'}))
          end

          it 'should include partial option on data attributes' do
            helper.should_receive(:render).with('/upload', model: album, relations: :photos, newAttachments: {}, loadedAttachments: {}, partial: 'albums/photo')

            helper.attachment_container(album, :photos, partial: 'albums/photo')
          end
        end

        context 'partial for images' do
          it 'should create a div with data-partial attributes' do
            helper.attachment_container(album, :photos, as: 'file').should eq(conteiner_html('album', 'photos', { id: 12345678, model: 'Album', relation: 'photos', partial: '/file'}))
          end

          it 'should include partial option on data attributes' do
            helper.should_receive(:render).with('/upload', model: album, relations: :photos, newAttachments: {}, loadedAttachments: {}, partial: '/file')

            helper.attachment_container(album, :photos, as: 'file')
          end
        end

        context 'embbeded models' do
          let(:track) { album.tracks.new }

          before do
            track.stub(id: '87654321')
          end

          it 'should create a div with data-embedded-in-id and data-embedded-in-model attributes' do
            helper.attachment_container(track, :files, embedded_in: album).should eq(conteiner_html('track', 'files', { id: 87654321, model: 'Track', embedded_in_id: 12345678, embedded_in_model: 'Album', relation: 'files', partial: '/image'}))
          end

          it 'should render /upload partial' do
            helper.should_receive(:render).with('/upload', model: track, relations: :files, newAttachments: {}, loadedAttachments: {}, partial: '/image')

            helper.attachment_container(track, :files, embedded_in: album)
          end
        end

        context 'customizing newAttachments element' do
          it 'should create a div with data attributes' do
            helper.attachment_container(album, :photos, newAttachments: { class: 'thumbnails' }).should eq(conteiner_html('album', 'photos', { id: 12345678, model: 'Album', relation: 'photos', partial: '/image' }))
          end

          it 'should render /upload partial with newAttachments attributes' do
            helper.should_receive(:render).with('/upload', model: album, relations: :photos, newAttachments: { class: 'thumbnails' }, loadedAttachments: {}, partial: '/image')

            helper.attachment_container(album, :photos, newAttachments: { class: 'thumbnails' })
          end
        end

        context 'customizing loadedAttachments element' do
          it 'should create a div with data attributes' do
            helper.attachment_container(album, :photos, loadedAttachments: { class: 'span3' }).should eq(conteiner_html('album', 'photos', { id: 12345678, model: 'Album', relation: 'photos', partial: '/image' }))
          end

          it 'should render /upload partial with loadedAttachments attributes' do
            helper.should_receive(:render).with('/upload', model: album, relations: :photos, newAttachments: {}, loadedAttachments: { class: 'span3' }, partial: '/image')

            helper.attachment_container(album, :photos, loadedAttachments: { class: 'span3' })
          end
        end
      end

      context 'with block' do
        it 'should create a div with data attributes and content inside' do
          expected =  conteiner_html('album', 'photos', { id: 12345678, model: 'Album', relation: 'photos', partial: '/image' }) { 'template here' }

          helper.attachment_container(album, :photos) { 'template here' }.should eq(expected)
        end
      end
    end
  end
end
