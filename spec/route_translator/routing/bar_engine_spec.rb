# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bar::Engine, type: :routing do
  describe Bar::WelcomeController, type: :routing do
    routes { Bar::Engine.routes }

    describe 'default routes' do
      it { expect(get: '/').to route_to({ 'controller' => 'bar/welcome', 'action' => 'index' }) }

      it { expect(get: '/sobre').to     route_to({ 'controller' => 'bar/pages', 'action' => 'about', 'locale' => 'es' }) }
      it { expect(get: '/pt/quem-e').to route_to({ 'controller' => 'bar/pages', 'action' => 'about', 'locale' => 'pt' }) }
      it { expect(get: '/en/about').to  route_to({ 'controller' => 'bar/pages', 'action' => 'about', 'locale' => 'en' }) }

      it { expect(get: about_path).to    route_to({ 'controller' => 'bar/pages', 'action' => 'about', 'locale' => 'es' }) }
      it { expect(get: about_es_path).to route_to({ 'controller' => 'bar/pages', 'action' => 'about', 'locale' => 'es' }) }
      it { expect(get: about_pt_path).to route_to({ 'controller' => 'bar/pages', 'action' => 'about', 'locale' => 'pt' }) }
      it { expect(get: about_en_path).to route_to({ 'controller' => 'bar/pages', 'action' => 'about', 'locale' => 'en' }) }
    end
  end

  describe Bar::ProductsController, type: :routing do
    routes { Bar::Engine.routes }

    describe 'test_resources' do
      context 'when locale is default locale' do
        let(:locale) { 'es' }

        it { expect(get: '/productos').to        route_to({ 'controller' => 'bar/products', 'action' => 'index', 'locale' => locale }) }
        it { expect(get: '/productos/1').to      route_to({ 'controller' => 'bar/products', 'action' => 'show', 'id' => '1', 'locale' => locale }) }
        it { expect(patch: '/productos/1').to    route_to({ 'controller' => 'bar/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
        it { expect(put: '/productos/1').to      route_to({ 'controller' => 'bar/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
        it { expect(delete: '/productos/1').to   route_to({ 'controller' => 'bar/products', 'action' => 'destroy', 'id' => '1', 'locale' => locale }) }
        it { expect(get: '/productos/1/edit').to route_to({ 'controller' => 'bar/products', 'action' => 'edit', 'id' => '1', 'locale' => locale }) }

        it { expect(get: products_path).to            route_to({ 'controller' => 'bar/products', 'action' => 'index', 'locale' => locale }) }
        it { expect(get: product_path(id: 1)).to      route_to({ 'controller' => 'bar/products', 'action' => 'show', 'id' => '1', 'locale' => locale }) }
        it { expect(patch: product_path(id: 1)).to    route_to({ 'controller' => 'bar/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
        it { expect(put: product_path(id: 1)).to      route_to({ 'controller' => 'bar/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
        it { expect(delete: product_path(id: 1)).to   route_to({ 'controller' => 'bar/products', 'action' => 'destroy', 'id' => '1', 'locale' => locale }) }
        it { expect(get: edit_product_path(id: 1)).to route_to({ 'controller' => 'bar/products', 'action' => 'edit', 'id' => '1', 'locale' => locale }) }

        it { expect(get: products_es_path).to            route_to({ 'controller' => 'bar/products', 'action' => 'index', 'locale' => locale }) }
        it { expect(get: product_es_path(id: 1)).to      route_to({ 'controller' => 'bar/products', 'action' => 'show', 'id' => '1', 'locale' => locale }) }
        it { expect(patch: product_es_path(id: 1)).to    route_to({ 'controller' => 'bar/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
        it { expect(put: product_es_path(id: 1)).to      route_to({ 'controller' => 'bar/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
        it { expect(delete: product_es_path(id: 1)).to   route_to({ 'controller' => 'bar/products', 'action' => 'destroy', 'id' => '1', 'locale' => locale }) }
        it { expect(get: edit_product_es_path(id: 1)).to route_to({ 'controller' => 'bar/products', 'action' => 'edit', 'id' => '1', 'locale' => locale }) }
      end

      context 'when locale is pt' do
        let(:locale) { 'pt' }

        it { expect(get: "/#{locale}/produtos").to        route_to({ 'controller' => 'bar/products', 'action' => 'index', 'locale' => locale }) }
        it { expect(get: "/#{locale}/produtos/1").to      route_to({ 'controller' => 'bar/products', 'action' => 'show', 'id' => '1', 'locale' => locale }) }
        it { expect(patch: "/#{locale}/produtos/1").to    route_to({ 'controller' => 'bar/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
        it { expect(put: "/#{locale}/produtos/1").to      route_to({ 'controller' => 'bar/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
        it { expect(delete: "/#{locale}/produtos/1").to   route_to({ 'controller' => 'bar/products', 'action' => 'destroy', 'id' => '1', 'locale' => locale }) }
        it { expect(get: "/#{locale}/produtos/1/edit").to route_to({ 'controller' => 'bar/products', 'action' => 'edit', 'id' => '1', 'locale' => locale }) }

        it { expect(get: products_pt_path).to            route_to({ 'controller' => 'bar/products', 'action' => 'index', 'locale' => locale }) }
        it { expect(get: product_pt_path(id: 1)).to      route_to({ 'controller' => 'bar/products', 'action' => 'show', 'id' => '1', 'locale' => locale }) }
        it { expect(patch: product_pt_path(id: 1)).to    route_to({ 'controller' => 'bar/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
        it { expect(put: product_pt_path(id: 1)).to      route_to({ 'controller' => 'bar/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
        it { expect(delete: product_pt_path(id: 1)).to   route_to({ 'controller' => 'bar/products', 'action' => 'destroy', 'id' => '1', 'locale' => locale }) }
        it { expect(get: edit_product_pt_path(id: 1)).to route_to({ 'controller' => 'bar/products', 'action' => 'edit', 'id' => '1', 'locale' => locale }) }
      end

      context 'when locale is en' do
        let(:locale) { 'en' }

        it { expect(get: "/#{locale}/products").to        route_to({ 'controller' => 'bar/products', 'action' => 'index', 'locale' => locale }) }
        it { expect(get: "/#{locale}/products/1").to      route_to({ 'controller' => 'bar/products', 'action' => 'show', 'id' => '1', 'locale' => locale }) }
        it { expect(patch: "/#{locale}/products/1").to    route_to({ 'controller' => 'bar/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
        it { expect(put: "/#{locale}/products/1").to      route_to({ 'controller' => 'bar/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
        it { expect(delete: "/#{locale}/products/1").to   route_to({ 'controller' => 'bar/products', 'action' => 'destroy', 'id' => '1', 'locale' => locale }) }
        it { expect(get: "/#{locale}/products/1/edit").to route_to({ 'controller' => 'bar/products', 'action' => 'edit', 'id' => '1', 'locale' => locale }) }

        it { expect(get: products_en_path).to            route_to({ 'controller' => 'bar/products', 'action' => 'index', 'locale' => locale }) }
        it { expect(get: product_en_path(id: 1)).to      route_to({ 'controller' => 'bar/products', 'action' => 'show', 'id' => '1', 'locale' => locale }) }
        it { expect(patch: product_en_path(id: 1)).to    route_to({ 'controller' => 'bar/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
        it { expect(put: product_en_path(id: 1)).to      route_to({ 'controller' => 'bar/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
        it { expect(delete: product_en_path(id: 1)).to   route_to({ 'controller' => 'bar/products', 'action' => 'destroy', 'id' => '1', 'locale' => locale }) }
        it { expect(get: edit_product_en_path(id: 1)).to route_to({ 'controller' => 'bar/products', 'action' => 'edit', 'id' => '1', 'locale' => locale }) }
      end
    end

    describe 'test_route_with_optional_format' do
      it { expect(get: '/productos.xml').to   route_to({ 'controller' => 'bar/products', 'action' => 'index', 'format' => 'xml', 'locale' => 'es' }) }
      it { expect(get: '/pt/produtos.xml').to route_to({ 'controller' => 'bar/products', 'action' => 'index', 'format' => 'xml', 'locale' => 'pt' }) }
      it { expect(get: '/en/products.xml').to route_to({ 'controller' => 'bar/products', 'action' => 'index', 'format' => 'xml', 'locale' => 'en' }) }
    end
  end

  describe Bar::PeopleController, type: :routing do
    routes { Bar::Engine.routes }

    describe 'test_route_with_mandatory_format' do
      it { expect(get: '/gente.xml').to      route_to({ 'controller' => 'bar/people', 'action' => 'index', 'format' => 'xml', 'locale' => 'es' }) }
      it { expect(get: '/pt/pessoas.xml').to route_to({ 'controller' => 'bar/people', 'action' => 'index', 'format' => 'xml', 'locale' => 'pt' }) }
      it { expect(get: '/en/people.xml').to  route_to({ 'controller' => 'bar/people', 'action' => 'index', 'format' => 'xml', 'locale' => 'en' }) }
    end
  end
end
