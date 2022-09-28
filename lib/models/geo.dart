class Goe {
  String? name;
  LocalNames? localNames;
  double? lat;
  double? lon;
  String? country;
  String? state;

  Goe(
      {this.name,
      this.localNames,
      this.lat,
      this.lon,
      this.country,
      this.state});

  Goe.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    localNames = json['local_names'] != null
        ? LocalNames.fromJson(json['local_names'])
        : null;
    lat = json['lat'];
    lon = json['lon'];
    country = json['country'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (localNames != null) {
      data['local_names'] = localNames!.toJson();
    }
    data['lat'] = lat;
    data['lon'] = lon;
    data['country'] = country;
    data['state'] = state;
    return data;
  }
}

class LocalNames {
  String? pt;
  String? vi;
  String? ur;
  String? tr;
  String? lt;
  String? en;
  String? ascii;
  String? eo;
  String? uk;
  String? cs;
  String? ms;
  String? fr;
  String? featureName;
  String? bg;
  String? eu;
  String? de;
  String? ja;
  String? kk;
  String? ky;
  String? ru;
  String? da;
  String? es;
  String? zh;
  String? fa;
  String? ar;
  String? nl;
  String? el;
  String? pl;
  String? sw;
  String? ko;

  LocalNames(
      {this.pt,
      this.vi,
      this.ur,
      this.tr,
      this.lt,
      this.en,
      this.ascii,
      this.eo,
      this.uk,
      this.cs,
      this.ms,
      this.fr,
      this.featureName,
      this.bg,
      this.eu,
      this.de,
      this.ja,
      this.kk,
      this.ky,
      this.ru,
      this.da,
      this.es,
      this.zh,
      this.fa,
      this.ar,
      this.nl,
      this.el,
      this.pl,
      this.sw,
      this.ko});

  LocalNames.fromJson(Map<String, dynamic> json) {
    pt = json['pt'];
    vi = json['vi'];
    ur = json['ur'];
    tr = json['tr'];
    lt = json['lt'];
    en = json['en'];
    ascii = json['ascii'];
    eo = json['eo'];
    uk = json['uk'];
    cs = json['cs'];
    ms = json['ms'];
    fr = json['fr'];
    featureName = json['feature_name'];
    bg = json['bg'];
    eu = json['eu'];
    de = json['de'];
    ja = json['ja'];
    kk = json['kk'];
    ky = json['ky'];
    ru = json['ru'];
    da = json['da'];
    es = json['es'];
    zh = json['zh'];
    fa = json['fa'];
    ar = json['ar'];
    nl = json['nl'];
    el = json['el'];
    pl = json['pl'];
    sw = json['sw'];
    ko = json['ko'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pt'] = pt;
    data['vi'] = vi;
    data['ur'] = ur;
    data['tr'] = tr;
    data['lt'] = lt;
    data['en'] = en;
    data['ascii'] = ascii;
    data['eo'] = eo;
    data['uk'] = uk;
    data['cs'] = cs;
    data['ms'] = ms;
    data['fr'] = fr;
    data['feature_name'] = featureName;
    data['bg'] = bg;
    data['eu'] = eu;
    data['de'] = de;
    data['ja'] = ja;
    data['kk'] = kk;
    data['ky'] = ky;
    data['ru'] = ru;
    data['da'] = da;
    data['es'] = es;
    data['zh'] = zh;
    data['fa'] = fa;
    data['ar'] = ar;
    data['nl'] = nl;
    data['el'] = el;
    data['pl'] = pl;
    data['sw'] = sw;
    data['ko'] = ko;
    return data;
  }
}
