require 'spec_helper'

describe MediaMagick do
  describe ApplicationHelper do
    describe 'attachmentUploader' do
      let(:album) { Album.new }

      before do
        album.stub(id: '12345678')
      end

      def conteiner_html(model, relation, type, data_attributes, &block)
        id = "#{model}-#{relation.to_s}-#{type.to_s}"
        classes  = "attachmentUploader"

        content_tag(:div, nil, id: id, class: classes, data: data_attributes) do
          class_eval(&block) if block_given?
        end
      end

      context 'without block' do
        before do
          # album.stub(id: '12345678')

          helper.stub(:render)
        end

        it 'should render /uploader partial' do
          helper.should_receive(:render).with('/uploader')

          helper.attachment_uploader(album, :photos, :image)
        end

        it 'should create a div with data attributes' do
          data_attributes = { id: 12345678, model: 'Album', relation: 'photos', partial: '/uploader' }
          html = conteiner_html('Album', 'photos', 'image', data_attributes)

          helper.attachment_uploader(album, :photos, :image).should eq(html)
        end

        context 'using partials' do
          it 'creates a div with data-partial attribute' do
            html = conteiner_html('Album', 'photos', 'image', { id: 12345678, model: 'Album', relation: 'photos', partial: 'albums/photo'})

            helper.attachment_uploader(album, :photos, :image, partial: 'albums/photo').should eq(html)
          end

          it 'creates a div with data-loader_partial attribute' do
            attrs = { id: 12345678, model: 'Album', relation: 'photos', partial: '/uploader', loader_partial: 'custom_loader'}
            html  = conteiner_html('Album', 'photos', 'image', attrs)

            helper.attachment_uploader(album, :photos, :image, loader_partial: 'custom_loader').should eq(html)
          end

          it 'includes partial option on data attributes' do
            helper.should_receive(:render).with('albums/photo')

            helper.attachment_uploader(album, :photos, :image, partial: 'albums/photo')
          end

        end

        # context 'partial for images' do
        #   xit 'should create a div with data-partial attributes' do
        #     helper.attachment_container(album, :photos, as: 'file').should eq(conteiner_html('album', 'photos', { id: 12345678, model: 'Album', relation: 'photos', partial: '/file'}))
        #   end

        #   xit 'should include partial option on data attributes' do
        #     helper.should_receive(:render).with('/upload', model: album, relations: :photos, newAttachments: {}, loadedAttachments: {}, partial: '/file')

        #     helper.attachment_container(album, :photos, as: 'file')
        #   end
        # end

        context 'embbeded models' do
          let(:track) { album.tracks.new }

          before do
            track.stub(id: '87654321')
          end

          it 'should create a div with data-embedded-in-id and data-embedded-in-model attributes' do
            html = conteiner_html('Track', 'files', 'file', { id: 87654321, model: 'Track', embedded_in_id: 12345678, embedded_in_model: 'Album', relation: 'files', partial: '/uploader'})

            helper.attachment_uploader(track, :files, :file, embedded_in: album).should eq(html)
          end

          xit 'should render /upload partial' do
            helper.should_receive(:render).with('/upload', model: track, relations: :files, newAttachments: {}, loadedAttachments: {}, partial: '/uploader')

            helper.attachment_container(track, :files, embedded_in: album)
          end
        end

        context 'customizing newAttachments element' do
          xit 'should create a div with data attributes' do
            helper.attachment_container(album, :photos, newAttachments: { class: 'thumbnails' }).should eq(conteiner_html('album', 'photos', { id: 12345678, model: 'Album', relation: 'photos', partial: '/image' }))
          end

          xit 'should render /upload partial with newAttachments attributes' do
            helper.should_receive(:render).with('/upload', model: album, relations: :photos, newAttachments: { class: 'thumbnails' }, loadedAttachments: {}, partial: '/image')

            helper.attachment_container(album, :photos, newAttachments: { class: 'thumbnails' })
          end
        end

        context 'customizing loadedAttachments element' do
          xit 'should create a div with data attributes' do
            helper.attachment_container(album, :photos, loadedAttachments: { class: 'span3' }).should eq(conteiner_html('album', 'photos', { id: 12345678, model: 'Album', relation: 'photos', partial: '/image' }))
          end

          xit 'should render /upload partial with loadedAttachments attributes' do
            helper.should_receive(:render).with('/upload', model: album, relations: :photos, newAttachments: {}, loadedAttachments: { class: 'span3' }, partial: '/image')

            helper.attachment_container(album, :photos, loadedAttachments: { class: 'span3' })
          end
        end
      end

      context 'with block' do
        xit 'should create a div with data attributes and content inside' do
          expected =  conteiner_html('album', 'photos', { id: 12345678, model: 'Album', relation: 'photos', partial: '/image' }) { 'template here' }

          helper.attachment_container(album, :photos) { 'template here' }.should eq(expected)
        end
      end
    end
  end
end
