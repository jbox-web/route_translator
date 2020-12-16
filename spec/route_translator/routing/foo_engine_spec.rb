# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Foo::WelcomeController, type: :routing do
  routes { Foo::Engine.routes }

  describe 'default routes' do
    it { expect(get: '/').to route_to({ 'controller' => 'foo/welcome', 'action' => 'index' }) }

    it { expect(get: '/quem-e').to   route_to({ 'controller' => 'foo/pages', 'action' => 'about', 'locale' => 'pt' }) }
    it { expect(get: '/es/sobre').to route_to({ 'controller' => 'foo/pages', 'action' => 'about', 'locale' => 'es' }) }
    it { expect(get: '/en/about').to route_to({ 'controller' => 'foo/pages', 'action' => 'about', 'locale' => 'en' }) }
  end
end

RSpec.describe Foo::ProductsController, type: :routing do
  routes { Foo::Engine.routes }

  describe 'test_resources' do
    context 'locale is default locale' do
      let(:locale) { 'pt' }

      it { expect(get: "/produtos").to      route_to({ 'controller' => 'foo/products', 'action' => 'index', 'locale' => locale }) }
      it { expect(get: "/produtos/1").to    route_to({ 'controller' => 'foo/products', 'action' => 'show', 'id' => '1', 'locale' => locale }) }
      it { expect(patch: "/produtos/1").to  route_to({ 'controller' => 'foo/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
      it { expect(put: "/produtos/1").to    route_to({ 'controller' => 'foo/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
      it { expect(delete: "/produtos/1").to route_to({ 'controller' => 'foo/products', 'action' => 'destroy', 'id' => '1', 'locale' => locale }) }
    end

    context 'locale is es' do
      let(:locale) { 'es' }

      it { expect(get: "/es/productos").to      route_to({ 'controller' => 'foo/products', 'action' => 'index', 'locale' => locale }) }
      it { expect(get: "/es/productos/1").to    route_to({ 'controller' => 'foo/products', 'action' => 'show', 'id' => '1', 'locale' => locale }) }
      it { expect(patch: "/es/productos/1").to  route_to({ 'controller' => 'foo/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
      it { expect(put: "/es/productos/1").to    route_to({ 'controller' => 'foo/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
      it { expect(delete: "/es/productos/1").to route_to({ 'controller' => 'foo/products', 'action' => 'destroy', 'id' => '1', 'locale' => locale }) }
    end

    context 'locale is en' do
      let(:locale) { 'en' }

      it { expect(get: "/#{locale}/products").to      route_to({ 'controller' => 'foo/products', 'action' => 'index', 'locale' => locale }) }
      it { expect(get: "/#{locale}/products/1").to    route_to({ 'controller' => 'foo/products', 'action' => 'show', 'id' => '1', 'locale' => locale }) }
      it { expect(patch: "/#{locale}/products/1").to  route_to({ 'controller' => 'foo/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
      it { expect(put: "/#{locale}/products/1").to    route_to({ 'controller' => 'foo/products', 'action' => 'update', 'id' => '1', 'locale' => locale }) }
      it { expect(delete: "/#{locale}/products/1").to route_to({ 'controller' => 'foo/products', 'action' => 'destroy', 'id' => '1', 'locale' => locale }) }
    end
  end

  describe 'test_route_with_optional_format' do
    it { expect(get: '/produtos.xml').to     route_to({ 'controller' => 'foo/products', 'action' => 'index', 'format' => 'xml', 'locale' => 'pt' }) }
    it { expect(get: '/es/productos.xml').to route_to({ 'controller' => 'foo/products', 'action' => 'index', 'format' => 'xml', 'locale' => 'es' }) }
    it { expect(get: '/en/products.xml').to  route_to({ 'controller' => 'foo/products', 'action' => 'index', 'format' => 'xml', 'locale' => 'en' }) }
  end
end

RSpec.describe Foo::PeopleController, type: :routing do
  routes { Foo::Engine.routes }

  describe 'test_route_with_mandatory_format' do
    it { expect(get: '/pessoas.xml').to   route_to({ 'controller' => 'foo/people', 'action' => 'index', 'format' => 'xml', 'locale' => 'pt'  }) }
    it { expect(get: '/es/gente.xml').to  route_to({ 'controller' => 'foo/people', 'action' => 'index', 'format' => 'xml', 'locale' => 'es'  }) }
    it { expect(get: '/en/people.xml').to route_to({ 'controller' => 'foo/people', 'action' => 'index', 'format' => 'xml', 'locale' => 'en'  }) }
  end
end
