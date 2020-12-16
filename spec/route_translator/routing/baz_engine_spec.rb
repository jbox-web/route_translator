# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Baz::WelcomeController, type: :routing do
  routes { Baz::Engine.routes }

  describe 'default routes' do
    it { expect(get: '/').to route_to({ 'controller' => 'baz/welcome', 'action' => 'index' }) }

    it { expect(get: '/a-propos').to  route_to({ 'controller' => 'baz/pages', 'action' => 'about', 'locale' => 'fr' }) }
    it { expect(get: '/es/sobre').to  route_to({ 'controller' => 'baz/pages', 'action' => 'about', 'locale' => 'es' }) }
    it { expect(get: '/pt/quem-e').to route_to({ 'controller' => 'baz/pages', 'action' => 'about', 'locale' => 'pt' }) }
    it { expect(get: '/en/about').to  route_to({ 'controller' => 'baz/pages', 'action' => 'about', 'locale' => 'en' }) }
  end
end

RSpec.describe Baz::ProductsController, type: :routing do
  routes { Baz::Engine.routes }

  describe 'test_resources' do
    context 'locale is default locale' do
      let(:locale) { 'fr' }

      it { expect(get: "/produits").to      route_to({ 'controller' => 'baz/products', 'action' => 'index', 'locale' => locale }) }
      it { expect(get: "/produits/1").to    route_to({ 'controller' => 'baz/products', 'action' => 'show', 'id' => '1', 'locale' => locale }) }
      it { expect(patch: "/produits/1").to  route_to({ 'controller' => 'baz/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
      it { expect(put: "/produits/1").to    route_to({ 'controller' => 'baz/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
      it { expect(delete: "/produits/1").to route_to({ 'controller' => 'baz/products', 'action' => 'destroy', 'id' => '1', 'locale' => locale }) }
    end

    context 'locale is es' do
      let(:locale) { 'es' }

      it { expect(get: "/es/productos").to      route_to({ 'controller' => 'baz/products', 'action' => 'index', 'locale' => locale }) }
      it { expect(get: "/es/productos/1").to    route_to({ 'controller' => 'baz/products', 'action' => 'show', 'id' => '1', 'locale' => locale }) }
      it { expect(patch: "/es/productos/1").to  route_to({ 'controller' => 'baz/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
      it { expect(put: "/es/productos/1").to    route_to({ 'controller' => 'baz/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
      it { expect(delete: "/es/productos/1").to route_to({ 'controller' => 'baz/products', 'action' => 'destroy', 'id' => '1', 'locale' => locale }) }
    end

    context 'locale is pt' do
      let(:locale) { 'pt' }

      it { expect(get: "/#{locale}/produtos").to      route_to({ 'controller' => 'baz/products', 'action' => 'index', 'locale' => locale }) }
      it { expect(get: "/#{locale}/produtos/1").to    route_to({ 'controller' => 'baz/products', 'action' => 'show', 'id' => '1', 'locale' => locale }) }
      it { expect(patch: "/#{locale}/produtos/1").to  route_to({ 'controller' => 'baz/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
      it { expect(put: "/#{locale}/produtos/1").to    route_to({ 'controller' => 'baz/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
      it { expect(delete: "/#{locale}/produtos/1").to route_to({ 'controller' => 'baz/products', 'action' => 'destroy', 'id' => '1', 'locale' => locale }) }
    end

    context 'locale is en' do
      let(:locale) { 'en' }

      it { expect(get: "/#{locale}/products").to      route_to({ 'controller' => 'baz/products', 'action' => 'index', 'locale' => locale }) }
      it { expect(get: "/#{locale}/products/1").to    route_to({ 'controller' => 'baz/products', 'action' => 'show', 'id' => '1', 'locale' => locale }) }
      it { expect(patch: "/#{locale}/products/1").to  route_to({ 'controller' => 'baz/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
      it { expect(put: "/#{locale}/products/1").to    route_to({ 'controller' => 'baz/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
      it { expect(delete: "/#{locale}/products/1").to route_to({ 'controller' => 'baz/products', 'action' => 'destroy', 'id' => '1', 'locale' => locale }) }
    end
  end

  describe 'test_route_with_optional_format' do
    it { expect(get: '/pt/produtos.xml').to  route_to({ 'controller' => 'baz/products', 'action' => 'index', 'format' => 'xml', 'locale' => 'pt' }) }
    it { expect(get: '/es/productos.xml').to route_to({ 'controller' => 'baz/products', 'action' => 'index', 'format' => 'xml', 'locale' => 'es' }) }
    it { expect(get: '/en/products.xml').to  route_to({ 'controller' => 'baz/products', 'action' => 'index', 'format' => 'xml', 'locale' => 'en' }) }
  end
end

RSpec.describe Baz::PeopleController, type: :routing do
  routes { Baz::Engine.routes }

  describe 'test_route_with_mandatory_format' do
    it { expect(get: '/pt/pessoas.xml').to route_to({ 'controller' => 'baz/people', 'action' => 'index', 'format' => 'xml', 'locale' => 'pt'  }) }
    it { expect(get: '/es/gente.xml').to   route_to({ 'controller' => 'baz/people', 'action' => 'index', 'format' => 'xml', 'locale' => 'es'  }) }
    it { expect(get: '/en/people.xml').to  route_to({ 'controller' => 'baz/people', 'action' => 'index', 'format' => 'xml', 'locale' => 'en'  }) }
  end
end
