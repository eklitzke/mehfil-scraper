import urllib
import re
import sys

tag_re = re.compile('<.*?>')
num_re = re.compile(r'\(\d\)')

if __name__ == '__main__':
	u = urllib.urlopen('http://mehfilindian.com/LunchMenuTakeOut.htm').read()
	s = u.find('height="539"')
	u = u[s:s+u[s:].find('<center>')]
	u = tag_re.sub('', u.replace('\n', '').replace('\r', '').replace('\t', ' ').replace('<br>','\n').replace('  ',' '))

	v = u

	positions = [-3]
	while u:
		m = num_re.search(u)
		if not m:
			break
		positions.append(m.start() + positions[-1] + 3)
		u = u[m.end():]
	positions = positions[1:]

	for x, y in zip(positions, positions[1:]):
		s = v[x:y].strip()
		try:
			print s.decode('windows-1252')
		except:
			print s
		print
	print '(%s)%s' % (len(positions), u)
